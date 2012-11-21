package net.richardlord.asteroids.systems
{
	import ash.core.NodeList;
	import ash.core.System;

	import net.richardlord.asteroids.EntityCreator;
	import net.richardlord.asteroids.nodes.AsteroidCollisionNode;
	import net.richardlord.asteroids.nodes.BulletCollisionNode;
	import net.richardlord.asteroids.nodes.SpaceshipCollisionNode;

	import flash.geom.Point;

	public class CollisionSystem extends System
	{
		[Inject]
		public var creator : EntityCreator;
		
		[Inject(nodeType="net.richardlord.asteroids.nodes.SpaceshipCollisionNode")]
		public var spaceships : NodeList;
		[Inject(nodeType="net.richardlord.asteroids.nodes.AsteroidCollisionNode")]
		public var asteroids : NodeList;
		[Inject(nodeType="net.richardlord.asteroids.nodes.BulletCollisionNode")]
		public var bullets : NodeList;

		override public function update( time : Number ) : void
		{
			var bullet : BulletCollisionNode;
			var asteroid : AsteroidCollisionNode;
			var spaceship : SpaceshipCollisionNode;

			for ( bullet = bullets.head; bullet; bullet = bullet.next )
			{
				for ( asteroid = asteroids.head; asteroid; asteroid = asteroid.next )
				{
					if ( Point.distance( asteroid.position.position, bullet.position.position ) <= asteroid.collision.radius )
					{
						creator.destroyEntity( bullet.entity );
						if ( asteroid.collision.radius > 10 )
						{
							creator.createAsteroid( asteroid.collision.radius - 10, asteroid.position.position.x + Math.random() * 10 - 5, asteroid.position.position.y + Math.random() * 10 - 5 );
							creator.createAsteroid( asteroid.collision.radius - 10, asteroid.position.position.x + Math.random() * 10 - 5, asteroid.position.position.y + Math.random() * 10 - 5 );
						}
						creator.destroyEntity( asteroid.entity );
						break;
					}
				}
			}

			for ( spaceship = spaceships.head; spaceship; spaceship = spaceship.next )
			{
				for ( asteroid = asteroids.head; asteroid; asteroid = asteroid.next )
				{
					if ( Point.distance( asteroid.position.position, spaceship.position.position ) <= asteroid.collision.radius + spaceship.collision.radius )
					{
						spaceship.spaceship.fsm.changeState( "destroyed" );
						break;
					}
				}
			}
		}
	}
}
