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
FROM python:3.9-slim

RUN apt-get update && apt-get install -y \
    libffi-dev \
    libstdc++6 \
    libopenblas-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /install /usr/local
COPY app.py sentiment_model.py ./

EXPOSE 5000

CMD ["python", "app.py"]