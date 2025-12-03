import ImportScript
from propertyLib import create_prpt, PrptClass, EnumClass


ary = [
    create_prpt("QString", 'statusText',
                init_val = '{"Not connected"}',
                is_writable  = True,
                is_notify = True, 
                is_list = False
                ),
    create_prpt("QString", 'timeStr',
                init_val = '{}',
                is_writable  = True,
                is_notify = True,
                is_list = False
                ),
    create_prpt("QString", 'ledStr',
                init_val = '{"0000000000000000"}',
                is_writable  = True,
                is_notify = True,
                is_list = False
                ),


]

enumClasss = []

prptClass = PrptClass("MyTypePrivate", ary, enumClasss)
