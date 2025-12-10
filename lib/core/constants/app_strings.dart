class AppStrings {
  // Auth - Login
  static const String loginTitle = 'Inicio de Sesión';
  static const String emailLabel = 'Email:';
  static const String passwordLabel = 'Contraseña:';
  static const String loginButton = 'Iniciar sesión';
  static const String noAccountQuestion = '¿No tienes cuenta?';
  static const String registerLink = 'Regístrate';

  // Auth - Register
  static const String registerTitle = 'Registro';
  static const String usernameLabel = 'Nombre de usuario:';
  static const String confirmPasswordLabel = 'Confirmar contraseña:';
  static const String registerButton = 'Registrarse';
  static const String hasAccountQuestion = '¿Ya tienes cuenta?';
  static const String loginLink = 'Inicia sesión';

  // API
  static const String baseUrl = 'http://192.168.0.8:3000';

  // Errors
  static const String emailRequired = 'El email es requerido';
  static const String passwordRequired = 'La contraseña es requerida';
  static const String usernameRequired = 'El nombre de usuario es requerido';
  static const String confirmPasswordRequired = 'Confirma tu contraseña';
  static const String passwordsNotMatch = 'Las contraseñas no coinciden';
  static const String invalidEmail = 'Email inválido';
  static const String loginError = 'Error al iniciar sesión';
  static const String registerError = 'Error al registrarse';

  // Report Incident
  static const String reportTitle = 'Reportar incidente';
  static const String reportError = 'Error al enviar reporte';
  static const String selectCategory = 'Seleccionar categoría';
  static const String selectCityHint = 'Seleccionar ciudad (opcional)';
  static const String cityLabel = 'Ciudad';
  static const String locationLabel = 'Ubicación';
  static const String myLocationButton = 'Mi ubicación';
  static const String descriptionLabel = 'Descripción (opcional)';
  static const String descriptionHint = 'Describe el incidente...';
  static const String photoLabel = 'Foto (opcional)';
  static const String cameraButton = 'Abrir cámara';
  static const String photoCaptured = 'Foto capturada';
  static const String deleteButton = 'Eliminar';
  static const String submitReportButton = 'Subir reporte';
  static const String reportSuccess = 'Incidente reportado exitosamente';
  static const String categoryRequired = 'Selecciona una categoría';
  static const String locationRequired = 'Obtén tu ubicación antes de reportar';

  // Profile
  static const String editButton = 'Editar';
  static const String saveButton = 'Guardar';
  static const String accountVerifiedLabel = 'Cuenta verificada:';
  static const String verifiedStatus = 'Verificado';
  static const String verifyButton = 'Verificar';
  static const String passwordChangeHint = 'Dejar vacío para no cambiar';
  static const String profileLoadError = 'No se pudo cargar el perfil';

  // My Reports
  static const String sortAscending = 'Ascendente';
  static const String sortDescending = 'Descendente';
  static const String retryButton = 'Reintentar';
  static const String noReportsEmpty = 'No tienes reportes aún';
  static const String closeButton = 'Cerrar';
}
