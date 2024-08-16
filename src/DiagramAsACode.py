from diagrams import Diagram
from diagrams.aws.compute import EC2
from diagrams.aws.database import RDS
from diagrams.aws.storage import S3
from diagrams.aws.network import APIGateway, CloudFront, Route53
from diagrams.aws.security import IAM
from diagrams.aws.integration import SQS
from diagrams.aws.management import Cloudwatch
from diagrams.aws.compute import Lambda

# Definindo o nome do arquivo de saída e o formato
with Diagram("Microserviços de E-commerce de Camisetas", show=False, outformat="png", filename="ecommerce_microservices_diagram_pt"):
    # Usuário acessando o serviço
    user = CloudFront("Usuário")

    # API Gateway
    api_gateway = APIGateway("API Gateway")

    # Balanceamento de carga
    lb = Route53("Balanceador de Carga")

    # Microserviço de autenticação
    auth_service = Lambda("Serviço de Autenticação")

    # Microserviço de catálogo de produtos
    catalog_service = Lambda("Serviço de Catálogo")

    # Microserviço de pedidos
    order_service = Lambda("Serviço de Pedidos")

    # Serviço de banco de dados (relacional)
    db = RDS("Banco de Dados")

    # Bucket S3 para armazenar imagens das camisetas
    storage = S3("Armazenamento de Imagens")

    # Fila SQS para processamento assíncrono de pedidos
    queue = SQS("Fila de Pedidos")

    # Serviço IAM para controle de acesso
    auth = IAM("Regras IAM")

    # Monitoramento com CloudWatch
    monitoring = Cloudwatch("Monitoramento")

    # Fluxo do diagrama
    user >> api_gateway >> lb >> [auth_service, catalog_service, order_service]
    catalog_service >> storage
    order_service >> [db, queue]
    api_gateway >> monitoring
    auth_service >> auth