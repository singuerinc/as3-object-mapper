package {

	import net.singuerinc.utils.Mapper;

	import flash.display.Sprite;

	public class Example extends Sprite {

		public function Example() {

			var userData:XML =
			<user uid="1" age="28">
				<firstName>John</firstName>
				<surname>Doe</surname>
				<friends>
					<friend>Robert</friend>
					<friend>Peter</friend>
					<friend>Jenny</friend>
				</friends>
				<!-- or <friends>Robert, Peter, Jenny</friends>-->
			</user>;

			var user:User = Mapper.mapTo(userData, User, true);
			trace(user.uid);// 1
			trace(user.name);// John
			trace(user.surname);// Doe
			trace(user.age);// 28
			trace(user.friends);// [Robert, Peter, Jenny]

		}
	}
}
