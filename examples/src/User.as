package {

	public class User {

		[Map(required=true)]
		public var uid:uint;

		[Map(required=true)]
		public var name:String;

		[Map(required=false)]
		public var surname:String;

		[Map]
		public var age:uint;

		public var hobbies:Array;
		public var nickname:String;
	}
}
