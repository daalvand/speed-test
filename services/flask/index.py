from flask import Flask

app = Flask(__name__)

@app.route('/hello-world')
def helloWorld():
    return 'Hello World'

if __name__ == '__main__':
    # For development testing, you can use the Flask development server with:
    app.run(host='0.0.0.0', port=80)
    # For production, use Gunicorn to run the app:
