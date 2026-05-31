import pandas as pd
import pyodbc
import matplotlib.pyplot as plt
from datetime import datetime

# ================================================
# CONEXIÓN A SQL SERVER
# ================================================
conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=localhost;'
    'DATABASE=integrador_analytics;'
    'Trusted_Connection=yes;'
)

# ================================================
# EXTRACCIÓN DE DATOS
# ================================================
df_ventas = pd.read_sql("SELECT * FROM vw_ventas", conn)
df_vendedores = pd.read_sql("SELECT * FROM vw_vendedores", conn)
conn.close()

# ================================================
# ANÁLISIS
# ================================================
print("=== RESUMEN EJECUTIVO ===")
print(f"Total ingresos:   ${df_ventas['ingreso'].sum():>12,.0f}")
print(f"Total ganancia:   ${df_ventas['ganancia'].sum():>12,.0f}")
print(f"Margen promedio:  {df_ventas['margen_pct'].mean():.1f}%")
print(f"Total unidades:   {df_ventas['cantidad'].sum():>12,.0f}")

print("\n=== TOP 3 PRODUCTOS ===")
top_prod = df_ventas.groupby('producto')['ganancia'].sum().sort_values(ascending=False).head(3)
print(top_prod.apply(lambda x: f"${x:,.0f}"))

print("\n=== VENDEDOR TOP ===")
top_vend = df_vendedores.sort_values('ingresos', ascending=False).iloc[0]
print(f"{top_vend['vendedor']} — ${top_vend['ingresos']:,.0f}")

# ================================================
# GRÁFICOS
# ================================================
fig, axes = plt.subplots(2, 2, figsize=(16, 10))
fig.suptitle('Reporte Ejecutivo — Sistema Integrador 2026',
             fontsize=16, fontweight='bold', color='#1A56A0')

# Gráfico 1: Ingresos por región
ingresos_region = df_ventas.groupby('region')['ingreso'].sum().sort_values()
axes[0,0].barh(ingresos_region.index, ingresos_region.values, color='#1A56A0')
axes[0,0].set_title('Ingresos por Región', fontweight='bold')
axes[0,0].xaxis.set_major_formatter(plt.FuncFormatter(lambda v,p: f'${v/1000000:.1f}M'))

# Gráfico 2: Ganancia por categoría
gan_cat = df_ventas.groupby('categoria')['ganancia'].sum().sort_values(ascending=False)
axes[0,1].bar(gan_cat.index, gan_cat.values, color='#2ECC71')
axes[0,1].set_title('Ganancia por Categoría', fontweight='bold')
axes[0,1].tick_params(axis='x', rotation=45)
axes[0,1].yaxis.set_major_formatter(plt.FuncFormatter(lambda v,p: f'${v/1000000:.1f}M'))

# Gráfico 3: Rendimiento de vendedores
vend = df_vendedores.sort_values('ingresos', ascending=False)
axes[1,0].barh(vend['vendedor'], vend['ingresos'], color='#E74C3C')
axes[1,0].set_title('Rendimiento de Vendedores', fontweight='bold')
axes[1,0].xaxis.set_major_formatter(plt.FuncFormatter(lambda v,p: f'${v/1000000:.1f}M'))

# Gráfico 4: Ingresos por segmento
seg = df_ventas.groupby('segmento')['ingreso'].sum()
colores = ['#1A56A0','#2ECC71','#E74C3C']
axes[1,1].pie(seg.values, labels=seg.index, autopct='%1.1f%%', colors=colores)
axes[1,1].set_title('Ingresos por Segmento', fontweight='bold')

plt.tight_layout()
plt.savefig('reporte_integrador.png', dpi=150, bbox_inches='tight')
plt.show()

# ================================================
# EXPORTAR A EXCEL
# ================================================
fecha_hoy = datetime.now().strftime("%Y%m%d")
archivo   = f"reporte_integrador_{fecha_hoy}.xlsx"

with pd.ExcelWriter(archivo, engine='openpyxl') as writer:
    df_ventas.to_excel(writer,     sheet_name='Detalle Ventas',   index=False)
    df_vendedores.to_excel(writer, sheet_name='Vendedores',       index=False)

    resumen = pd.DataFrame({
        'Concepto': ['Total Ingresos','Total Ganancia','Margen %','Total Unidades'],
        'Valor': [
            df_ventas['ingreso'].sum(),
            df_ventas['ganancia'].sum(),
            round(df_ventas['margen_pct'].mean(), 1),
            df_ventas['cantidad'].sum()
        ]
    })
    resumen.to_excel(writer, sheet_name='Resumen Ejecutivo', index=False)

print(f"\nReporte generado: {archivo}")
print("Imagen guardada:  reporte_integrador.png")


import traceback
try:
    with pd.ExcelWriter(archivo, engine='openpyxl') as writer:
        df_ventas.to_excel(writer,     sheet_name='Detalle Ventas',   index=False)
        df_vendedores.to_excel(writer, sheet_name='Vendedores',       index=False)
        resumen.to_excel(writer,       sheet_name='Resumen Ejecutivo', index=False)
    print(f"\nReporte generado: {archivo}")
except Exception as e:
    print(f"\nERROR al generar Excel: {e}")
    traceback.print_exc()