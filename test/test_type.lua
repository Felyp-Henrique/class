_ENV = require('external.lunity')(
    "test the base creation type with Type"
)

Type = require("class").Type

function test:test_create_type_and_extend_other()
    local AnyGenericClass = {
        __statics = {
            StaticFieldBase = "StaticFieldBase"
        },
        __fields = {
            FieldBase = "FieldBase"
        }
    }
    local AnySpecializedClass = {}
    assertDoesNotError(Type.extend, Type, AnySpecializedClass, AnyGenericClass)
    assertNotNil(AnySpecializedClass.__statics)
    assertNotNil(AnySpecializedClass.__statics.StaticFieldBase)
    assertEqual(AnySpecializedClass.__statics.StaticFieldBase, "StaticFieldBase")
    assertNotNil(AnySpecializedClass.__fields)
    assertNotNil(AnySpecializedClass.__fields.FieldBase)
    assertEqual(AnySpecializedClass.__fields.FieldBase, "FieldBase")
end

function test:test_create_type_with_statics_values()
    local AnyClassDefinition = {}
    assertDoesNotError(Type.static, Type, AnyClassDefinition, "AnyField", "AnyValue")
    assertNotNil(AnyClassDefinition.__statics)
    assertNotNil(AnyClassDefinition.__statics.AnyField)
    assertEqual(AnyClassDefinition.__statics.AnyField, "AnyValue")
end

function test:test_create_type_with_fields()
    local AnyClassDefinition = {}
    assertDoesNotError(Type.field, Type, AnyClassDefinition, "AnyField", "AnyValue")
    assertNotNil(AnyClassDefinition.__fields)
    assertNotNil(AnyClassDefinition.__fields.AnyField)
    assertEqual(AnyClassDefinition.__fields.AnyField, "AnyValue")
end

test()