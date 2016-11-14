
from bottle import route, run, request, response, static_file, debug, template

import json
import os
import pandas as pd


debug(True)


@route('/show_movie')
def show_movie():
    id = request.query.id
    return template('show_movie', id=id)

@route('/<fname:re:(css|js|movies)?/?.*.(css|js|html|mp4)>')
def serve_static_file(fname):
    return static_file(fname, root='.')

@route('/log_data', method='POST')
def log_data():
    #response.content_type = 'application/json'
    data = request.json['data']
    id = request.json['id']
    outfile = os.path.join('data','{}.csv'.format(id))
    df = pd.DataFrame({'t': [d[0] for d in data],
                        'value': [d[1] for d in data]})

    df.to_csv(outfile, index=False)

    return {"message": "data written"}



#run(host='localhost', port=8080)
run(server='wsgiref')
