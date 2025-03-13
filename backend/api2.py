from flask import Flask


app = Flask(__name__)

def handler(event, context):
    print("handler invoked")
    return {
        'statusCode': 200
    }
    #return serverless_wsgi.handle_request(app, event, context)

#if __name__ == '__main__':
 #   app.run(host='0.0.0.0', port=5000, debug=True)

