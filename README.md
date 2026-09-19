# 🍕 Sistema de Gestión para Pizzería "Don Piccolo"

Bienvenido al repositorio del sistema de base de datos relacional diseñado para la **Pizzería Don Piccolo**. Este proyecto implementa un modelo de datos robusto (normalizado hasta 3NF/BCNF) optimizado para la gestión transaccional (OLTP) de pedidos, inventarios, control de personal, domicilios y analítica de negocio.

---

## 📋 Descripción del Proyecto

El sistema de la Pizzería Don Piccolo automatiza el flujo operativo completo de un negocio gastronómico:
* **Gestión de Personas, Clientes y Repartidores:** Estructura basada en herencia lógica donde la tabla base `persona` alimenta tanto a clientes como a repartidores mediante una relación de uno a uno estricta.
* **Control de Menú y Recetas:** Catálogo de pizzas vinculado a los ingredientes necesarios para su elaboración (`pizza_ingrediente`).
* **Procesamiento de Pedidos y Domicilios:** Registro detallado de cada orden, cálculo de subtotales, asignación de entregas y cálculo automático de totales con IVA.
* **Automatización con Lógica de Base de Datos:** Uso avanzado de funciones matemáticas y financieras, procedimientos almacenados y disparadores (`triggers`) para el control automático de stock, auditoría de precios y disponibilidad del personal.

---

## 🗂️ Explicación de las Tablas y Relaciones

El esquema está compuesto por 10 tablas principales interconectadas de la siguiente manera:

1. **`persona`**: Tabla base que almacena la información de contacto común (nombre, apellido, teléfono, dirección, correo único).
2. **`cliente`**: Extiende a `persona` mediante una llave foránea compartida. Almacena los puntos de fidelización del cliente.
3. **`repartidor`**: Extiende a `persona` de forma similar. Registra la zona asignada y el estado actual (`DISPONIBLE` o `NO DISPONIBLE`).
4. **`pizza`**: Catálogo de productos disponibles con su respectivo tamaño, tipo y precio base.
5. **`ingrediente`**: Inventario de materias primas con control de stock actual, mínimo y costo unitario.
6. **`pizza_ingrediente`**: Tabla intermedia (N:M) que define la receta exacta de cada pizza (qué cantidad de cada ingrediente requiere).
7. **`pedido`**: Cabecera de las órdenes realizadas por los clientes, incluyendo fecha, método de pago, estado (`PENDIENTE`, `EN PREPARACION`, `ENTREGADO`, `CANCELADO`) y total.
8. **`detalle_pedido`**: Tabla intermedia (1:N) que registra las pizzas específicas y cantidades que componen un pedido.
9. **`domicilio`**: Control logístico de los envíos asociados a un pedido y a un repartidor, registrando tiempos de salida/entrega, distancia en kilómetros y costo de envío.
10. **`historial_precios`**: Tabla de auditoría para registrar de forma automática cualquier cambio de precio base realizado en las pizzas.

---

## ⚙️ Componentes Programables

El sistema incorpora lógica avanzada directamente en el motor de base de datos MySQL:
* **Funciones:**
  * `calcular_total_pedido(p_id_pedido)`: Calcula de forma dinámica el costo total sumando las pizzas, el domicilio y aplicando el IVA del 19%.
  * `calcular_ganancia_neta_diaria(p_fecha)`: Determina la rentabilidad real de un día restando los costos de los ingredientes a las ventas totales.
* **Procedimientos Almacenados:**
  * `registrar_entrega_domicilio(p_id_domicilio, p_hora_entrega)`: Actualiza la hora de entrega de un envío y cambia automáticamente el estado del pedido asociado a `ENTREGADO`.
* **Triggers (Disparadores):**
  * `actualizar_stock_ingredientes`: Descuenta automáticamente del inventario los ingredientes requeridos tras registrar un detalle de pedido.
  * `auditoria_cambio_precio_pizza`: Registra un histórico en la tabla `historial_precios` cada vez que se modifica el precio de una pizza.
  * `marcar_repartidor_disponible`: Cambia automáticamente el estado del repartidor a `DISPONIBLE` al registrarse la entrega de su domicilio.

---

## 📊 Ejemplos de Consultas y Reportes Clave

El sistema incluye vistas preparadas para la toma de decisiones rápidas:
* **Resumen de Pedidos por Cliente:** Muestra el total acumulado de compras y dinero gastado por cada cliente.
* **Desempeño de Repartidores:** Analiza el número de entregas realizadas, la distancia promedio y el tiempo de entrega.
* **Control de Stock Crítico:** Identifica instantáneamente los ingredientes cuyo stock actual se encuentra por debajo del mínimo permitido.

Ejemplo de consulta para ver el stock crítico:
```sql
SELECT * FROM vista_stock_critico_ingredientes;
