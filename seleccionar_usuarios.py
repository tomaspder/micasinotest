import psycopg2
import random

# Configuración de conexión a la base de datos
DB_HOST = '34.155.170.155'
DB_PORT = '5432'
DB_NAME = 'micasino'
DB_USER = 'postgres'
DB_PASSWORD = 'postgres'

try:
    conn = psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    cursor = conn.cursor()

    # Seleccionar 3 usuarios aleatorios
    cursor.execute("SELECT id, email FROM usuarios ORDER BY RANDOM() LIMIT 3")
    users = cursor.fetchall()

    # Imprimir los usuarios seleccionados
    print("Usuarios seleccionados:")
    for user in users:
        print("ID:", user[0], "Email:", user[1])

except psycopg2.Error as e:
    print("Error al conectar a la base de datos:", e)

finally:
    if conn is not None:
        conn.close()
