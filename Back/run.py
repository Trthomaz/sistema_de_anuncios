from app import app
from app.models.tables import Anuncio

if __name__ == "__main__":#Feito para rodar a aplicacao
    #db.create_all()
    app.run(host='0.0.0.0', port=5000, debug=True)