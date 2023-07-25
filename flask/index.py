from flask import Flask

app = Flask(__name__)

@app.route('/hello-world')
def helloWorld():
    return 'Hello World'

app.run(host='0.0.0.0', port=80)
