package {

	import net.singuerinc.utils.Mapper;

	import flash.display.Sprite;

	public class Main extends Sprite {

		public function Main() {

			var userData:XML =
			<user uid="1" age="29">
				<name>John</name>
				<surname>Doe</surname>
			</user>;

			var user:User = Mapper.mapTo(userData, User);
			trace(user.uid);// 1
			trace(user.name);// John
			trace(user.surname);// Doe
			trace(user.age);// 28

		}
	}
}
