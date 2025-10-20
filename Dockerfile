# Etapa 1: Construcción (builder)
FROM python:3.9-slim AS builder

# Instala dependencias del sistema necesarias para compilar paquetes
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Crea directorio de trabajo
WORKDIR /app

# Copia archivos del proyecto
COPY requirements.txt ./

# Instala dependencias en un entorno aislado
RUN pip install --upgrade pip \
    && pip install --no-cache-dir --prefix=/install -r requirements.txt

# Etapa 2: Imagen final
FROM python:3.9-alpine

# Instala dependencias mínimas del sistema
RUN apk add --no-cache libffi curl

# Crea directorio de trabajo
WORKDIR /app

# Copia solo lo necesario desde la etapa anterior
COPY --from=builder /install /usr/local
COPY app.py sentiment_model.py ./

# Expone el puerto de Flask
EXPOSE 5000

# Comando para ejecutar la API
CMD ["python", "app.py"]