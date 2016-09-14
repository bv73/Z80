        ORG     #8000
        DI
        LD      HL,0
        LD      DE,#C000
        LD      BC,#3FFF
        IN      A,(#FB)
        LDIR
        IN      A,(#7B)
        EI
        RET

