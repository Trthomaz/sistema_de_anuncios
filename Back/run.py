from app import app

if __name__ == "__main__":#Feito para rodar a aplicacao
    #db.create_all()
    app.run(host='0.0.0.0', port=5000, debug=True)