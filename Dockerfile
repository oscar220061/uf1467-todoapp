# --- Etapa 1: Construcción (Build) ---
    FROM node:18-alpine AS build

    WORKDIR /app
    
    # Copiamos los archivos de dependencias
    COPY package*.json ./
    
    # Instalamos dependencias
    RUN npm install
    
    # Copiamos el resto del código del proyecto
    COPY . .
    
    # Generamos los archivos estáticos de producción (crea la carpeta build)
    RUN npm run build
    
    # --- Etapa 2: Producción (Runtime) ---
    FROM nginx:alpine
    
    # Copiamos los archivos estáticos desde la etapa de compilación al directorio de Nginx
    COPY --from=build /app/build /usr/share/nginx/html
    
    # Expone el puerto 80 para el tráfico web
    EXPOSE 80
    
    # Arranca Nginx en primer plano
    CMD ["nginx", "-g", "daemon off;"]