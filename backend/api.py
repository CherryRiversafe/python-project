from flask import Flask,jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from sqlalchemy_utils import database_exists, create_database
import boto3
import os


app = Flask(__name__)
CORS(app)

SECRET_NAME_username = os.getenv('dbUserNameSecret').replace('"','')
SECRET_NAME_passwd = os.getenv('dbPasswordSecret').replace('"', '')
REGION_NAME = 'eu-west-2'


def get_secret(secret_name):
    session = boto3.session.Session()
    client = session.client(service_name='secretsmanager')
    try:
        response = client.get_secret_value(SecretId=secret_name)
        if 'SecretString' in response:
            return response['SecretString']
    except Exception as e:
        print(e)
        return None
    
secret_username = get_secret(SECRET_NAME_username)
secret_password = get_secret(SECRET_NAME_passwd)

rds_endpoint = os.getenv('dbEndpoint').replace('"','')

db_name = 'bucketListDB'
full_db_url = f'postgresql://{secret_username}:{secret_password}@{rds_endpoint}/{db_name}'

app.config['SQLALCHEMY_DATABASE_URI'] = (full_db_url)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class BucketListTable(db.Model):
    __tablename__ = "Bucket_List"
    id = db.Column(db.String, primary_key=True)
    user_id = db.Column(db.String)
    item = db.Column(db.String)
    checked = db.Column(db.Boolean)
    def to_dict(self):
        return {
            'id' :self.id,
            'user_id': self.user_id,
            'item': self.item,
            'checked': self.checked,
        }


if not database_exists(full_db_url):
    create_database(full_db_url)
else:
    print("No updates were necessary.")

# Create all tables in the database based on the models
with app.app_context():
    db.create_all()
    print("Tables created successfully.")




@app.route('/')
def home():
    return({'stat_code': 200})


@app.route('/add_item/<user_id>', methods=['POST'])
def add_item(user_id):
    print('add item called')
    data = request.json
    new_item = BucketListTable(id=data['id'], user_id=user_id, item=data['item'], checked=data['checked'])
    db.session.add(new_item)
    db.session.commit()
    print('message : item added successfully')
    return jsonify({'message': 'item added successfully'})

@app.route('/update_item/<id>', methods=['PUT', 'POST'])
def update_item(id):
    print(f'attempting to update item with id {id}')
    item = BucketListTable.query.filter_by(id=id).first()
    print(f'retrieved item {item}')
    if item:
        data = request.json
        item.checked = bool(data['checked'])
        db.session.commit()
        return 'item updated successfully'
    return ' not found', 404


@app.route('/get_list/<user_id>', methods=['GET'])
def get_list(user_id):
    try:
        items = BucketListTable.query.filter_by(user_id=user_id).all()
        if items:
            for item in items:
                print(item)
            return jsonify([item.to_dict() for item in items]), 200
        else:
            return jsonify({"message": "No items found for this user"}), 200
    except Exception as e:
        print(f"Error: {str(e)}")
        return jsonify({"message": "An error occurred"}), 500
            

@app.route('/delete_item/<item_id>', methods=['DELETE'])
def delete_item(item_id):
    print(f'attempting to delete item with id {item_id}')
    item = BucketListTable.query.filter_by(id = item_id).first()
    db.session.delete(item)
    db.session.commit()
    return {"message": "Item deleted."}, 200



if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

