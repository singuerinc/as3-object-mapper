package {

	public class User {
		// required value
		[Map(required=true)]
		public var uid:uint;

		// map from different prop name
		[Map(required=true, mapFrom='firstName')]
		public var name:String;

		// optional map ( mapped only if exist in source )
		[Map(required=false)]
		public var surname:String;

		// optional mapping, only if exist in source and "strict" mapping is set to true (default)
		[Map]
		public var age:uint;

		[Map]
		public var friends:Array;

		// no mapped props
		public var nickname:String;
		public var hobbies:Array;
	}
}
