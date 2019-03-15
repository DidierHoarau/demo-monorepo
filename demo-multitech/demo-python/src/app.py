from flask import Flask
import socket

app = Flask(__name__)

@app.route("/")
def hello():
    return "python @" + socket.gethostname() + " (Python v5)"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int("80"))
