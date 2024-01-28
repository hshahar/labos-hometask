from flask import Flask, jsonify
import requests
import os

app = Flask(__name__)

@app.route('/<user>/<repo>', methods=['GET'])
def get_latest_release(user, repo):
    try:
        url = f"https://api.github.com/repos/{user}/{repo}/releases/latest"
        response = requests.get(url)
        data = response.json()

        # Test the result (version)
        if 'tag_name' in data:
            return jsonify({'version': data['tag_name']})
        else:
            return jsonify({'error': 'Release information not found'}), 404
    except requests.RequestException as e:
        return jsonify({'error': 'Failed to fetch data from GitHub', 'details': str(e)}), 500


if __name__ == "__main__":
    port = int(os.environ.get('PORT', 5000))
    app.run(debug=True, host='0.0.0.0', port=port)