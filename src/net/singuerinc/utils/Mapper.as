package net.singuerinc.utils {

	import flash.net.URLVariables;
	import flash.utils.describeType;

	/**
	 * @author nahuel.scotti
	 */
	public class Mapper {

		public static const MAPPER_METADATA_NAME:String = 'Map';
		public static const REQUIRED__ATTR:String = 'required';
		public static const MAP_TO__ATTR:String = 'mapTo';
		public static const MAP_FROM__ATTR:String = 'mapFrom';

		public static function mapAllTo(source:XMLList, Clazz:Class, strict:Boolean = true):Array {
			var objs:Array = [];
			for each (var item:XML in source) {
				objs.push(mapTo(item, Clazz, strict));
			}
			return objs;
		}

		public static function mapTo(source:XML, Clazz:Class, strict:Boolean = true):* {
			return createInstanceOf(source, Clazz, strict);
		}

		public static function mapToURLVariables(obj:*):URLVariables {
			var vars:URLVariables = new URLVariables();
			var objVars:XMLList = describeType(obj).variable;
			for each (var variable:XML in objVars) {
				if (!variable.hasOwnProperty('metadata')) continue;
				if (variable.metadata.(@name == MAPPER_METADATA_NAME).length() == 0) continue;

				var varName:String = variable.@name;
				var metaNode:XML = variable.metadata.(@name == MAPPER_METADATA_NAME)[0];
				var mapToValue:String = metaNode.arg.(@key == MAP_TO__ATTR).@value;
				var pRequired:Boolean = metaNode.arg.(@key == REQUIRED__ATTR).@value == 'true';
				var mapTo:String = mapToValue ? mapToValue : varName;
				if (pRequired || mapToValue) {
					vars[mapTo] = obj[varName];
				}
			}
			return vars;
		}

		private static function createInstanceOf(data:XML, Clazz:Class, strict:Boolean):* {

			var instance:* = new Clazz();
			var description:XML = describeType(instance);
			var vars:XMLList = description.variable;

			for each (var node:XML in vars) {

				if (!node.hasOwnProperty('metadata')) continue;
				if (node.metadata.(@name == MAPPER_METADATA_NAME).length() == 0) continue;

				var pName:String = String(node.@name);
				var mapFrom:String;
				var metaNode:XML = node.metadata.(@name == MAPPER_METADATA_NAME)[0];
				var pRequired:Boolean = metaNode.arg.(@key == REQUIRED__ATTR).@value == 'true';
				var mapFromValue:String = metaNode.arg.(@key == MAP_FROM__ATTR).@value;
				mapFrom = mapFromValue ? mapFromValue : pName;

				var value:*;

				if (data.hasOwnProperty(mapFrom)) {
					value = data.child(mapFrom)[0];
				} else if (data.attribute(mapFrom).length() == 1) {
					value = data.attribute(mapFrom)[0];
				} else if (pRequired || strict) {
					throw new Error('"' + pName + '" property in ' + description.@name + ' is required!');
				} else {
					// no mapping???
					// FIXME: Esto es correcto?
					value = null;
				}

				var instanceVarType:String = describeType(instance).variable.(@name == pName)[0].@type;

				if (value) {
					// TODO: Implementar más tipos??
					switch(instanceVarType.toLocaleLowerCase()) {
						case 'int':
						case 'uint':
						case 'number':
							instance[pName] = Number(value);
							break;
						case 'array':
							instance[pName] = String(value).split(',');
							break;
						// case '__as3__.vec::vector.<string>':
						// instance[pName] = new Vector.<String>();
						// instance[pName].push.apply(instance[pName], String(value).split(','));
						// break;
						case 'string':
							instance[pName] = String(value);
							break;
						default:
							throw new Error('Error ?' + instanceVarType);
					}
				} else {
					instance[pName] = null;
				}
			}

			return instance;
		}
	}
}
