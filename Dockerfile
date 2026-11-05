# ---------------------------------------------------------------
# Dockerfile : TP3 (jour 3)
# ---------------------------------------------------------------

# Image de base Python légère
FROM python:3.12-slim

# Dossier de travail dans le conteneur
WORKDIR /app

# Dépendances d'abord (couche mise en cache tant que requirements.txt ne change pas)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Code de l'application (change souvent : copié après les dépendances)
COPY app/ ./app/

# Utilisateur non-root
RUN useradd --create-home --uid 10001 appuser
USER appuser

# Version injectée au build : docker build --build-arg APP_VERSION=0.1.0 ...
ARG APP_VERSION=dev
ENV APP_VERSION=${APP_VERSION}

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app.main:app"]
