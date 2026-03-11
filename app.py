from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector

app = Flask(__name__)
CORS(app)  

# MySQL config — update password if needed!
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="flutterform"
)
cursor = db.cursor()

# Route: Submit form data
@app.route('/submit', methods=['POST'])
def submit():
    data = request.get_json()
    try:
        sql = "INSERT INTO submissions (name, email, phone, dob, gender) VALUES (%s, %s, %s, %s, %s)"
        values = (data['name'], data['email'], data['phone'], data['dob'], data['gender'])
        cursor.execute(sql, values)
        db.commit()
        return jsonify({"message": "Data submitted successfully!"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Route: Get all submissions
@app.route('/submissions', methods=['GET'])
def get_submissions():
    cursor.execute("SELECT * FROM submissions")
    rows = cursor.fetchall()
    result = []
    for row in rows:
        result.append({
            "id": row[0],
            "name": row[1],
            "email": row[2],
            "phone": row[3],
            "dob": str(row[4]),
            "gender": row[5]
        })
    return jsonify(result)

if __name__ == '__main__':
    app.run(debug=True)