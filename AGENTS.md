⚠️ Este proyecto comparte el proyecto Firebase (`ingresos-gastos-pwa-2026`) con
`IngresosYGastos/` y `USDT/` (migrado el 2026-09-24). Sitio de Hosting de esta
carpeta: `conciliador-jdm` → https://conciliador-jdm.web.app

Las reglas e índices de Firestore se despliegan SOLO desde `IngresosYGastos/`:
NO agregues la sección 'firestore' a este `firebase.json` — es intencional
que no esté, para evitar sobrescribir las reglas compartidas.

App estática (`public/index.html`, sin build): el `firebaseConfig` inline debe
apuntar siempre a `ingresos-gastos-pwa-2026`. Los datos viven en
`artifacts/paypal-auditor-pro/users/<uid>/movements` (+ `abonos/`).

El proyecto viejo `conciliador-pro-cloud` queda solo como backup de los datos
originales: no desplegarle.
