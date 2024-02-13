from faker import Faker
import psycopg2
import string
import random

# Configuración de conexión a la base de datos
DB_HOST = '34.155.170.155'  
DB_PORT = '5432' 
DB_NAME = 'micasino' 
DB_USER = 'postgres' 
DB_PASSWORD = 'postgres' 

# Crear un objeto Faker para generar datos aleatorios
faker = Faker()

# Función para generar un correo electrónico único
def generate_unique_email():
    return faker.email()

# Conectar a la base de datos
try:
    conn = psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    cursor = conn.cursor()

    # Insertar datos en la tabla usuarios
    for _ in range(1000):
        while True:
            email = generate_unique_email()
            password = ''.join(random.choices(string.ascii_letters + string.digits, k=12))
            try:
                cursor.execute("INSERT INTO usuarios (email, password) VALUES (%s, %s) RETURNING id", (email, password))
                user_id = cursor.fetchone()[0]  # Obtener el ID del usuario insertado
                break  # Salir del bucle si la inserción fue exitosa
            except psycopg2.IntegrityError:
                # Si se produce una violación de clave única, generar un nuevo correo electrónico y volver a intentarlo
                pass

        # Insertar datos en la tabla perfiles_usuario
        nombre = faker.first_name()
        apellidos = faker.last_name()
        direccion = faker.address()
        cursor.execute("INSERT INTO perfiles_usuario (usuario_id, nombre, apellidos, direccion) VALUES (%s, %s, %s, %s)", (user_id, nombre, apellidos, direccion))

    # Confirmar los cambios y cerrar la conexión
    conn.commit()
    print("Datos insertados correctamente.")

except psycopg2.Error as e:
    print("Error al conectar a la base de datos:", e)

finally:
    if conn is not None:
        conn.close()
