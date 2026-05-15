import os
import re

lib_dir = "lib"

# regex to find .withOpacity(value)
pattern = re.compile(r'\.withOpacity\(([^)]+)\)')

count = 0
for root, dirs, files in os.walk(lib_dir):
    for f in files:
        if f.endswith(".dart"):
            filepath = os.path.join(root, f)
            with open(filepath, 'r', encoding='utf-8') as file:
                content = file.read()
            
            new_content = pattern.sub(r'.withValues(alpha: \1)', content)
            
            if new_content != content:
                with open(filepath, 'w', encoding='utf-8') as file:
                    file.write(new_content)
                count += 1

print(f"Fixed {count} files.")
