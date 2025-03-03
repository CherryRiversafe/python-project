import pytest
import boto3
from moto import mock_aws
from api import app, db
from unittest.mock import MagicMock
import ssl



# Mock SSL wrap_socket if it doesn't exist
if not hasattr(ssl, 'wrap_socket'):
    ssl.wrap_socket = MagicMock()

@pytest.fixture(scope='function')
def aws_credentials():
    import os
    os.environ['AWS_ACCESS_KEY_ID'] = 'testing'
    os.environ['AWS_SECRET_ACCESS_KEY'] = 'testing'
    os.environ['AWS_SECURITY_TOKEN'] = 'testing'
    os.environ['AWS_SESSION_TOKEN'] = 'testing'

@pytest.fixture(scope='function')
def rds_client(aws_credentials):
    with mock_aws():
        yield boto3.client('rds', region_name='us-east-1')

@pytest.fixture(scope='function')
def mock_rds_instance(rds_client):
    rds_client.create_db_instance(
        DBInstanceIdentifier='test-db',
        Engine='postgres',
        DBInstanceClass='db.t2.micro',
        MasterUsername='testuser',
        MasterUserPassword='testpassword',
        AllocatedStorage=20
    )
    yield

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        with app.app_context():
            db.create_all()
        yield client
    db.drop_all()

def test_rds_instance_created(rds_client, mock_rds_instance):
    instances = rds_client.describe_db_instances()['DBInstances']
    assert len(instances) == 1
    assert instances[0]['DBInstanceIdentifier'] == 'test-db'

def test_home(client):
    response = client.get('/')
    assert response.status_code == 200
    assert response.json == {'stat_code': 200}

def test_add_item(client):
    response = client.post('/add_item/user1', json={
        'id': '1',
        'item': 'Test Item',
        'checked': False
    })
    assert response.status_code == 200
    assert response.json == {'message': 'item added successfully'}

def test_get_list(client):
    # Add a test item
    client.post('/add_item/user1', json={
        'id': '1',
        'item': 'Test Item',
        'checked': False
    })
    
    response = client.get('/get_list/user1')
    assert response.status_code == 200
    assert len(response.json) == 1
    assert response.json[0]['item'] == 'Test Item'

def test_update_item(client):
    # Add a test item
    client.post('/add_item/user1', json={
        'id': '1',
        'item': 'Test Item',
        'checked': False
    })
    
    response = client.put('/update_item/1', json={'checked': True})
    assert response.status_code == 200
    assert response.data == b'item updated successfully'

def test_delete_item(client):
    # Add a test item
    client.post('/add_item/user1', json={
        'id': '1',
        'item': 'Test Item',
        'checked': False
    })
    
    response = client.delete('/delete_item/1')
    assert response.status_code == 200
    assert response.json == {"message": "Item deleted."}



if __name__ == '__main__':
    pytest.main(['-v', '-s'])
