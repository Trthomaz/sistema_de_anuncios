from app import app
from zeroconf import Zeroconf, ServiceInfo
import socket
import uuid


def register_mdns():
    zeroconf = Zeroconf()
    unique_service_name = f"ServidorFabio-{uuid.uuid4().hex}._http._tcp.local."
    unique_service_name = f"FabioGabrielServerCruzeiro2027-._http._tcp.local."

    info = ServiceInfo(
        "_http._tcp.local.",
        unique_service_name,
        addresses=[socket.inet_aton("192.168.0.128")],
        port=5000,
        properties={"info": "Servidor DNS local"},
    )

    try:
        zeroconf.register_service(info)
        print(f"\nServiço mDNS registrado como {unique_service_name}\n")
    except Exception as e:
        print(f"\nErro ao registrar o serviço mDNS: {e}\n")


if __name__ == "__main__":#Feito para rodar a aplicacao
    #db.create_all()

    register_mdns()
    app.run(host='0.0.0.0', port=5000, threaded=True, debug=True)
