import pytest
import json
import boto3
import os
from api import app, db, BucketListTable


SECRET_NAME_username = os.getenv('TF_VAR_DB_USERNAME').replace('"','')
SECRET_NAME_passwd = os.getenv('TF_DB_PASSWORD').replace('"', '')
REGION_NAME = 'eu-west-2'


def get_secret(secret_name):
    print("getting secret..")
    session = boto3.session.Session()
    client = session.client(service_name='secretsmanager', region_name=REGION_NAME)
    print("configured client")
    try:
        response = client.get_secret_value(SecretId=secret_name)
        print("got secret response")
        if 'SecretString' in response:
            return response['SecretString']
    except Exception as e:
        print(e)
        return None
    
secret_username = get_secret(SECRET_NAME_username)
secret_password = get_secret(SECRET_NAME_passwd)

rds_endpoint = os.getenv('TF_RDS_ENDPOINT').replace('"','')

print(f'RDS Endpoint: {rds_endpoint}')


db_uri = f'postgresql://{secret_username}:{secret_password}@{rds_endpoint}/bucketListDB'

@pytest.fixture
def client():
    app.config['TESTING'] = True
    app.config['SQLALCHEMY_DATABASE_URI'] = db_uri

    with app.app_context():
        db.create_all()
    with app.test_client() as client:
        yield client
    with app.app_context():
        db.session.remove()
        db.drop_all()

def test_home_route(client):
    response = client.get('/')
    assert response.status_code == 200
    assert response.json == {'stat_code': 200}

def test_add_item(client):
    test_item = {
        'id' : 1,
        'item': 'Test Item',
        'checked': False
    }
    response = client.post('/add_item/user1', json = test_item)
    assert response.status_code == 200
    assert response.json == {'message': 'item added successfully'}

def test_get_list(client):
    items = [{'id': '1', 'item': 'Item 1', 'checked': False},
        {'id': '2', 'item': 'Item 2', 'checked': True}]
    for item in items:
        res =  client.post('/add_item/user1', json=item)
        assert res.status_code  == 200

    response = client.get('/get_list/user1')
    response.status_code == 200
    data = json.loads(response.data)
    print(data)
    assert len(data) == 2
    assert data[0]['item'] == 'Item 1'
    assert data[1]['item'] == 'Item 2'

def test_delete_item(client):
    # Add an item first
    test_item = {
        'id': '1',
        'item': 'Test Item',
        'checked': False
    }
    client.post('/add_item/user1', json=test_item)

    # Now delete the item
    response = client.delete('/delete_item/1')
    assert response.status_code == 200
    assert response.json == {"message": "Item deleted."}


