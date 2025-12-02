import ImportScript
from propertyLib import create_prpt, PrptClass, EnumClass


ary = [
    create_prpt("QString", 'statusText',
                init_val = '{"Not connected"}',
                is_writable  = True,
                is_notify = True, 
                is_list = False
                )
]

enumClasss = []

prptClass = PrptClass("MyTypePrivate", ary, enumClasss)
