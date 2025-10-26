import json
import os
from django.conf import settings
from django.utils import timezone
from decimal import Decimal

def get_manual_fuel_prices():
    """Get prices from manual JSON file - MAIN FUNCTION TO USE"""
    try:
        file_path = os.path.join(settings.BASE_DIR, 'fuel_prices.json')
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
            
        return {
            'gasoline': Decimal(str(data['gasoline'])),
            'diesel': Decimal(str(data['diesel'])),
            'kerosene': Decimal(str(data['kerosene'])),
            'region': data.get('region', 'National Average'),
            'source': data.get('source', 'DOE Philippines'),
            'success': True
        }
    except Exception as e:
        print(f"Manual price file error: {e}")
        # Fallback to current prices
        return {
            'gasoline': Decimal('68.45'),
            'diesel': Decimal('61.25'),
            'kerosene': Decimal('70.15'),
            'region': 'National Average',
            'source': 'DOE Philippines (Fallback)',
            'success': False
        }

def update_manual_fuel_prices(gasoline, diesel, kerosene, source="DOE Philippines"):
    """Update the manual fuel prices JSON file"""
    try:
        file_path = os.path.join(settings.BASE_DIR, 'fuel_prices.json')
        data = {
            "gasoline": float(gasoline),
            "diesel": float(diesel),
            "kerosene": float(kerosene),
            "region": "National Average",
            "source": source,
            "last_manual_update": timezone.now().strftime("%Y-%m-%d")
        }
        
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=4)
        
        print(f"Fuel prices updated: Gas ₱{gasoline}, Diesel ₱{diesel}, Kerosene ₱{kerosene}")
        return True
    except Exception as e:
        print(f"Error updating fuel prices: {e}")
        return False

# Keep this function for compatibility with your existing code
def get_live_fuel_prices():
    """Alias for get_manual_fuel_prices"""
    return get_manual_fuel_prices()