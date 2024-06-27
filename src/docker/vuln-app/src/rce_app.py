from flask import Flask, request
import subprocess
import sys

app = Flask(__name__)

@app.route('/run')
def run_cmd():
    cmd = request.args.get('cmd')
    if cmd:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)

        sys.stdout.write(result.stdout)
        sys.stderr.write(result.stderr)

        response = result.stdout
        if result.stderr:
            response += "\n" + result.stderr

        return response, 200
    else:
        return "No command provided", 400 # Bad request

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=6000)
