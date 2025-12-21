import ImportScript
from propertyLib import create_prpt, PrptClass, EnumClass


ary = [
    create_prpt("QString", 'statusText',
                init_val = '{"Not started"}',
                is_writable  = True,
                is_notify = True, 
                is_list = False
                ),
    create_prpt("QList<QColor>", 'rgbLeds', 
                init_val = "{ QColor(0,0,0), QColor(0,0,0) }",
                is_writable  = False,
                is_notify = True, 
                is_list = False                
                )            

]

enumClasss = []

prptClass = PrptClass("MyTypePrivate", ary, enumClasss)
