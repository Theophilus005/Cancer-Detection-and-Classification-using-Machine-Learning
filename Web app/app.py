import numpy as np
import tensorflow as tf
from flask import Flask, render_template, request
from keras.models import load_model
from keras.utils import load_img
from keras.utils import img_to_array
import requests
import json


app = Flask(__name__)
#Load the model
general_model = load_model('C:/Users/Theophilus/Downloads/Documents/Final year project/models/general_model.h5')
all_model = load_model('C:/Users/Theophilus/Downloads/Documents/Final year project/models/all_model.h5')
brain_cancer_model = load_model('C:/Users/Theophilus/Downloads/Documents/Final year project/models/brain_cancer_model.h5')
breast_cancer_model = load_model('C:/Users/Theophilus/Downloads/Documents/Final year project/models/breast_cancer_model.h5')
cervical_cancer_model = load_model('C:/Users/Theophilus/Downloads/Documents/Final year project/models/cervical_cancer_model.h5')
kidney_cancer_model = load_model('C:/Users/Theophilus/Downloads/Documents/Final year project/models/kidney_cancer_model.h5')
lung_colon_cancer_model = load_model('C:/Users/Theophilus/Downloads/Documents/Final year project/models/lung_colon_cancer_model.h5')
lymphoma_model = load_model('C:/Users/Theophilus/Downloads/Documents/Final year project/models/lymphoma_model.h5')
oral_cancer_model = load_model('C:/Users/Theophilus/Downloads/Documents/Final year project/models/oral_cancer_model.h5')

model_array = [all_model, brain_cancer_model, breast_cancer_model, cervical_cancer_model, kidney_cancer_model, lung_colon_cancer_model, lymphoma_model, oral_cancer_model]


#Class names
general_class_names = ['ALL', 'Brain Cancer', 'Breast Cancer', 'Cervical Cancer', 'Kidney Cancer', 'Lung and Colon Cancer', 'Lymphoma', 'Oral Cancer']
all_class_names = ['all_benign', 'all_early', 'all_pre', 'all_pro']
brain_class_names = ['brain_gioma', 'brain_menin', 'brain_tumor']
breast_class_names = ['breast_benign', 'breast_malignant']
cervical_class_names = ['cervix_dyk', 'cervix_koc', 'cervix_mep', 'cervix_pab', 'cervix_sfi']
kidney_class_names = ['kidney_normal', 'kidney_tumor']
lung_colon_class_names = ['colon_aca', 'colon_bnt', 'lung_aca', 'lung_bnt', 'lung_scc']
lymphoma_class_names = ['lymph_cll', 'lymph_fl', 'lymph_mcl']
oral_class_names = ['oral_normal', 'oral_scc']

class_names_array = [all_class_names, brain_class_names, breast_class_names, cervical_class_names, kidney_class_names, lung_colon_class_names, lymphoma_class_names, oral_class_names]

#Routes
@app.route('/', methods=['GET'])
def hello_world():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
    #Get form details
    patient_name = request.form['patient-name']
    patient_sex = request.form['patient-sex']
    patient_age = request.form ['patient-age']
    imagefile = request.files['image']
    imagepath = "C:/Users/Theophilus/Downloads/Documents/Final year project/Web app/images/" + imagefile.filename
    imagefile.save(imagepath)

    #Predict cancer type
    img = load_img(imagepath, target_size=(180, 180))
    img_array = img_to_array(img)
    img_array = tf.expand_dims(img_array, 0)

    prediction1 = general_model.predict(img_array)
    score1 = tf.nn.softmax(prediction1[0])
    class_figure = np.argmax(score1)
    cancer_type = general_class_names[class_figure]
    confidence1 = 100 * np.max(score1)
    print(cancer_type)

    #Predict cancer class
    selected_model = model_array[class_figure]
    prediction2 = selected_model.predict(img_array)
    score2 = tf.nn.softmax(prediction2[0])
    selected_class = class_names_array[class_figure]
    class_name = selected_class[np.argmax(score2)]
    confidence2 = 100 * np.max(score2)
    print(class_name)

    

    #Upload to database
    url = "https://cancer-0269.restdb.io/rest/patients"

    payload = json.dumps( {
        "patient_name": patient_name, 
        "patient_sex": patient_sex,
        "patient_age": patient_age,
        "cancer_type": cancer_type,
        "class_name": class_name,
        "confidence1": confidence1,
        "confidence2": confidence2
        } )
    
    headers = {
    'content-type': "application/json",
    'x-apikey': "b94869cad9c05798c0282f577707871a8db92",
    'cache-control': "no-cache"
    }
    response = requests.request("POST", url, data=payload, headers=headers)
    print(response.text)


    return render_template('results.html', patient_name=patient_name, patient_sex=patient_sex, patient_age=patient_age, cancer_type=cancer_type, class_name=class_name, confidence1=confidence1, confidence2=confidence2)

@app.route('/results', methods=['GET', 'POST'])
def results():
    return render_template('results.html')

@app.route('/tests', methods=['GET', 'POST'])
def test():
    

    return render_template('index.html')


if __name__ == '__main__':
    app.run(port=3000, debug=True)