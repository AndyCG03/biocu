# Biocu 🌱

Sistema móvil para conciencia ambiental en Cuba. Aplicación Flutter con backend NestJS que permite reportar problemas ambientales y acceder a contenido educativo sobre normativas ambientales cubanas.

## 🏗️ Estructura del Proyecto

```
biocu/
├── 📱 biocu/          # Aplicación Flutter (frontend)
└── 🖥️ biocu-api/      # API NestJS (backend)
```

## 🚀 Instalación Rápida

### 1. Clonar el repositorio
```bash
git clone https://github.com/AndyCG03/biocu.git
cd biocu
```

### 2. Configurar Frontend (Flutter)
```bash
cd biocu
flutter pub get
```

### 3. Configurar Backend (NestJS)
```bash
cd biocu-api
npm install
```

## ⚙️ Configuración

### 🔧 Variables de Entorno (Backend)
Crear archivo `.env` en `biocu-api/`:
```env
DATABASE_URL="postgresql://postgres:hola@localhost:5432/biocu_database"
PORT=3000
```

### 🔗 Configurar API URL (Frontend)
Editar `biocu/lib/core/constants/api_constants.dart`:
```dart
static const String baseUrl = "http://localhost:3000"; // Local
// static const String baseUrl = "https://tu-backend.com"; // Producción
```

## 🏃‍♂️ Ejecutar el Proyecto

### Backend (NestJS)
```bash
cd biocu-api

# Desarrollo
npm run start:dev

# Producción
npm run start:prod
```

### Frontend (Flutter)
```bash
cd biocu

flutter run -d android
```

## 📋 Características

### 📝 Reportes Ambientales
- Crear reportes con fotos y ubicación GPS
- Moderación de contenido por administradores
- Categorización de problemas ambientales

### 📚 Contenido Educativo
- Normativas ambientales cubanas
- Guías de buenas prácticas
- Información sobre biodiversidad

### 🔄 Sincronización
- Funcionamiento offline/online
- Sincronización automática al recuperar conexión
- Caché inteligente de contenido

## 🛠️ Stack Tecnológico

### Frontend
- **Flutter 3.7+** - Framework multiplataforma
- **Provider** - Gestión de estado
- **Geolocator** - Ubicación GPS
- **Camera/Image Picker** - Manejo de imágenes

### Backend
- **NestJS** - Framework Node.js
- **PostgreSQL** - Base de datos
- **Prisma ORM** - Manejo de base de datos
- **JWT** - Autenticación

## 📱 Pruebas

### Frontend
```bash
cd biocu
flutter test
```

### Backend
```bash
cd biocu-api
# Pruebas unitarias
npm run test

# Pruebas e2e
npm run test:e2e

# Cobertura
npm run test:cov
```

## 🐛 Solución de Problemas

### Problema: No se conecta al backend
- Verificar que el servidor NestJS esté corriendo (`localhost:3000`)
- Revisar la URL en `api_constants.dart`
- Verificar permisos de red

### Problema: Error de base de datos
- Asegurar que PostgreSQL esté instalado y corriendo
- Verificar credenciales en `.env`
- Ejecutar migraciones si es necesario

## 🤝 Contribuir

1. Fork el repositorio
2. Crear rama de feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit cambios (`git commit -m 'Agrega nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abrir Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 📞 Contacto

- **Autores:** AndyCG03 y R0ger0l1va
- **GitHub:** [@AndyCG03](https://github.com/AndyCG03) y [@R0ger0l1va](https://github.com/R0ger0l1va)
- **Issues:** [Reportar problema](https://github.com/AndyCG03/biocu/issues)

---

**Biocu** - Conciencia ambiental al alcance de todos
