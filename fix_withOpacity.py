#!/usr/bin/env python3
"""
Script para reemplazar withOpacity deprecado con withValues en archivos Dart
"""

import os
import re
import glob

def fix_withOpacity_in_file(file_path):
    """Reemplaza withOpacity con withValues en un archivo"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Patrón para encontrar withOpacity(0.XX)
        pattern = r'\.withOpacity\(([^)]+)\)'
        
        def replace_with_values(match):
            opacity_value = match.group(1)
            return f'.withValues(alpha: {opacity_value})'
        
        new_content = re.sub(pattern, replace_with_values, content)
        
        if new_content != content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"✅ Arreglado: {file_path}")
            return True
        else:
            print(f"⏭️  Sin cambios: {file_path}")
            return False
            
    except Exception as e:
        print(f"❌ Error en {file_path}: {e}")
        return False

def main():
    """Función principal"""
    # Buscar todos los archivos .dart
    dart_files = glob.glob("lib/**/*.dart", recursive=True)
    
    print(f"🔍 Encontrados {len(dart_files)} archivos Dart")
    
    fixed_count = 0
    for file_path in dart_files:
        if fix_withOpacity_in_file(file_path):
            fixed_count += 1
    
    print(f"\n🎉 Proceso completado!")
    print(f"📁 Archivos procesados: {len(dart_files)}")
    print(f"🔧 Archivos arreglados: {fixed_count}")

if __name__ == "__main__":
    main()
