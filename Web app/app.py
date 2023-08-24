import numpy as np
import tensorflow as tf
from flask import Flask, render_template, request, redirect, session
from keras.models import load_model
from keras.utils import load_img
from keras.utils import img_to_array
from random import randint
import requests
import json
import datetime


app = Flask(__name__)
HEX_SEC_KEY = 'd5fb8c4fa8bd46638dadc4e751e0d68d'
app.config['SECRET_KEY'] = HEX_SEC_KEY
app.secret_key = HEX_SEC_KEY

# Databse url endpoints
auth_db = "https://cancer-0269.restdb.io/rest/auth"
patients_db = "https://cancer-0269.restdb.io/rest/patients"

# Headers
headers = {
    'content-type': "application/json",
    'x-apikey': "b94869cad9c05798c0282f577707871a8db92",
    'cache-control': "no-cache"
}

# All 8 Models
general_model = load_model(
    'C:/Users/Theophilus/Downloads/Documents/Final year project/models/general_model.h5')
all_model = load_model(
    'C:/Users/Theophilus/Downloads/Documents/Final year project/models/all_model.h5')
brain_cancer_model = load_model(
    'C:/Users/Theophilus/Downloads/Documents/Final year project/models/brain_cancer_model.h5')
breast_cancer_model = load_model(
    'C:/Users/Theophilus/Downloads/Documents/Final year project/models/breast_cancer_model.h5')
cervical_cancer_model = load_model(
    'C:/Users/Theophilus/Downloads/Documents/Final year project/models/cervical_cancer_model.h5')
kidney_cancer_model = load_model(
    'C:/Users/Theophilus/Downloads/Documents/Final year project/models/kidney_cancer_model.h5')
lung_colon_cancer_model = load_model(
    'C:/Users/Theophilus/Downloads/Documents/Final year project/models/lung_colon_cancer_model.h5')
lymphoma_model = load_model(
    'C:/Users/Theophilus/Downloads/Documents/Final year project/models/lymphoma_model.h5')
oral_cancer_model = load_model(
    'C:/Users/Theophilus/Downloads/Documents/Final year project/models/oral_cancer_model.h5')

model_array = [all_model, brain_cancer_model, breast_cancer_model, cervical_cancer_model,
               kidney_cancer_model, lung_colon_cancer_model, lymphoma_model, oral_cancer_model]


# Class names for all cancer types
general_class_names = ['ALL', 'Brain Cancer', 'Breast Cancer', 'Cervical Cancer',
                       'Kidney Cancer', 'Lung and Colon Cancer', 'Lymphoma', 'Oral Cancer']
all_class_names = ['all_benign', 'all_early', 'all_pre', 'all_pro']
brain_class_names = ['brain_gioma', 'brain_menin', 'brain_tumor']
breast_class_names = ['breast_benign', 'breast_malignant']
cervical_class_names = ['cervix_dyk', 'cervix_koc',
                        'cervix_mep', 'cervix_pab', 'cervix_sfi']
kidney_class_names = ['kidney_normal', 'kidney_tumor']
lung_colon_class_names = ['colon_aca', 'colon_bnt',
                          'lung_aca', 'lung_bnt', 'lung_scc']
lymphoma_class_names = ['lymph_cll', 'lymph_fl', 'lymph_mcl']
oral_class_names = ['oral_normal', 'oral_scc']

class_names_array = [all_class_names, brain_class_names, breast_class_names, cervical_class_names,
                     kidney_class_names, lung_colon_class_names, lymphoma_class_names, oral_class_names]

# Check if user is logged in
def auth_check():
    if "user" in session:
        return redirect('/')
    else:
        return redirect('/login')



# Home Route
@app.route('/', methods=['GET'])
def home():
    # Check if user is logged in
    auth_check()
    return render_template("index.html")


# Predict Route
@app.route('/predict', methods=['POST'])
def predict():
    auth_check()

    # Get form details
    patient_name = request.form['patient-name']
    patient_sex = request.form['patient-sex']
    patient_age = request.form['patient-age']
    imagefile = request.files['image']
    imagepath = "C:/Users/Theophilus/Downloads/Documents/Final year project/Web app/images/" + imagefile.filename
    imagefile.save(imagepath)

    # Predict cancer type
    img = load_img(imagepath, target_size=(180, 180))
    img_array = img_to_array(img)
    img_array = tf.expand_dims(img_array, 0)

    prediction1 = general_model.predict(img_array)
    score1 = tf.nn.softmax(prediction1[0])
    class_figure = np.argmax(score1)
    cancer_type = general_class_names[class_figure]
    confidence1 = 100 * np.max(score1)
    print(cancer_type)

    # Predict cancer class
    selected_model = model_array[class_figure]
    prediction2 = selected_model.predict(img_array)
    score2 = tf.nn.softmax(prediction2[0])
    selected_class = class_names_array[class_figure]
    class_name = selected_class[np.argmax(score2)]
    confidence2 = 100 * np.max(score2)
    print(class_name)


    payload = json.dumps({
        "patient_name": patient_name,
        "patient_sex": patient_sex,
        "patient_age": patient_age,
        "cancer_type": cancer_type,
        "class_name": class_name,
        "doctor": session["user"],
        "date": str(datetime.datetime.now()),
        "confidence1": confidence1,
        "confidence2": confidence2
    })

   
    response = requests.request("POST", patients_db, data=payload, headers=headers)
    print(response.text)

    return render_template('results.html', patient_name=patient_name, patient_sex=patient_sex, patient_age=patient_age, cancer_type=cancer_type, class_name=class_name, confidence1=confidence1, confidence2=confidence2)


# Login Route
@app.route('/login', methods=['GET', 'POST'])
def login():

    if request.method == "POST":
        # Get login details
        username = request.form['username']
        password = request.form['password']

        data = json.dumps({
            "username": username,
            "password": password
        })

        # Check database
        url = auth_db + '?q='+data

        response = requests.request("GET", url, headers=headers)
        if len(response.json()) == 0:
            err_msg = "Invalid username/password"
            return render_template('login.html', err_msg=err_msg)
        else:
            # Create session
            session["user"] = username
            session["id"] = response.json()[0]['_id']
            return redirect('/')
        
    return render_template('login.html')


#Account Route
@app.route('/account', methods=['GET', 'POST'])
def account():

    account_id = session['id']
    url = auth_db + "/" + account_id
    msg = request.args.get('msg')
    
    if request.method == "GET":   
        response = requests.request("GET", url, headers=headers)    
        data = response.json()
        print(data)

    if request.method == "POST":
        old_password = request.form['old_password']
        new_password = request.form['new_password']

        #Check if old password is correct
        details = json.dumps({
            "username": session['user'],
            "password": old_password
        })

        #Check database
        url_check = auth_db + "?q="+details
        response = requests.request("GET", url_check, headers=headers)
        if len(response.json()) == 0:
            msg = "Invalid username/password"
            return redirect('/account?msg='+msg)
        else:
            #Update Password
            payload = json.dumps( {"password": new_password} )
            response = requests.request("PUT", url, data=payload, headers=headers)
            msg = "Password changed"
            return redirect('/account?msg='+msg)
    
    return render_template('account.html', data=data, msg=msg)


#Manage Route
@app.route('/manage', methods=['GET', 'POST'])
def manage():
    auth_check()

    if request.method == "POST":
        username = request.form['username']
        account_type = request.form['account_type']
        password = str(randint(0, 10000))

        payload = json.dumps({
            "username": username,
            "account_type": account_type,
            "password": password,
            "created_on": str(datetime.datetime.now()),
            "last_analysis": "N/A"
        })

        response = requests.request(
            "POST", auth_db, data=payload, headers=headers)
        
        print(response.text)
        return redirect('/manage?password='+str(password))

    else:
        password = request.args.get("password")             

        response = requests.request(
            "GET", auth_db, headers=headers)
        
        print(response.json())
        return render_template('manage.html', len=len(response.json()), users=response.json(), password=password)


#Records Route
@app.route('/records', methods=['GET', 'POST'])
def records():
    auth_check()

    response = requests.request("GET", patients_db, headers=headers)    
    print(response.json())
    return render_template('records.html', len=len(response.json()), patients=response.json())


#Logout Route
@app.route('/logout', methods=['GET', 'POST'])
def logout():
    session.pop("user", None)
    session.pop("id", None)
    return redirect("/login")


#Delete User
@app.route('/delete_user', methods=['GET', 'POST'])
def delete_user():
    auth_check()

    delete_id = request.args.get('id')
    url = auth_db + "/" + delete_id

    response = requests.request("DELETE", url, headers=headers)

    print(response.text)
    return redirect('/manage')


# Delete Record
@app.route('/delete_record', methods=['GET', 'POST'])
def delete_record():
    auth_check()

    delete_id = request.args.get('id')
    url = patients_db + "/" + delete_id

    response = requests.request("DELETE", url, headers=headers)

    print(response.text)
    return redirect('/records')


# tests
@app.route('/tests', methods=['GET', 'POST'])
def test():

    print(str(datetime.datetime.now())[0:10])

    return render_template('index.html')


#App Configuration
if __name__ == '__main__':
    app.run(port=3000, debug=True)
    HEX_SEC_KEY = 'd5fb8c4fa8bd46638dadc4e751e0d68d'
    app.config['SECRET_KEY'] = HEX_SEC_KEY
    app.secret_key = HEX_SEC_KEY
