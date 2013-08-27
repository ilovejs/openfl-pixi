package pixi.display;


import pixi.core.Point;
import pixi.textures.Texture;
import pixi.Pixi;


/**
 * @author Mat Groves http://matgroves.com/ @Doormat23
 * @author Joshua Granick
 */
class Sprite extends DisplayObjectContainer {
	
	
	/**
	 * The anchor sets the origin point of the texture.
	 * The default is 0,0 this means the textures origin is the top left 
	 * Setting than anchor to 0.5,0.5 means the textures origin is centered
	 * Setting the anchor to 1,1 would mean the textures origin points will be the bottom right
	 *
     * @property anchor
     * @type Point
     */
	public var anchor:Point;
	
	/**
	 * The blend mode of sprite.
	 * currently supports PIXI.blendModes.NORMAL and PIXI.blendModes.SCREEN
	 *
	 * @property blendMode
	 * @type Number
	 */
	public var blendMode:BlendModes;
	
	/**
	 * The height of the sprite, setting this will actually modify the scale to acheive the value set
	 *
	 * @property height
	 * @type Number
	 */
	public var height (get, set):Float;
	
	/**
	 * The texture that the sprite is using
	 *
	 * @property texture
	 * @type Texture
	 */
	public var texture:Texture;
	public var textureChange:Bool;
	public var updateFrame:Bool;
	
	/**
	 * The width of the sprite, setting this will actually modify the scale to acheive the value set
	 *
	 * @property width
	 * @type Number
	 */
	public var width (get, set):Float;
	
	private var _width:Float;
	private var _height:Float;
	
	
	/**
	 * The Sprite object is the base for all textured objects that are rendered to the screen
	 *
	 * @class Sprite
	 * @extends DisplayObjectContainer
	 * @constructor
	 * @param texture {Texture} The texture for this sprite
	 * @type String
	 */
	public function new (texture:Texture) {
		
		super ();
		
		this.anchor = new Point();
		this.texture = texture;
		this.blendMode = BlendModes.NORMAL;
		this._width = 0;
		this._height = 0;
		
		if(texture.baseTexture.hasLoaded)
		{
			this.updateFrame = true;
		}
		else
		{
			this.texture.addEventListener( 'update', onTextureUpdate);
		}
		
		this.renderable = true;
		
	}
	
	
	/**
	 * When the texture is updated, this event will fire to update the scale and frame
	 *
	 * @method onTextureUpdate
	 * @param event
	 * @private
	 */
	private function onTextureUpdate (event:Dynamic):Void {
		
		//this.texture.removeEventListener( 'update', this.onTextureUpdateBind );
		
		// so if _width is 0 then width was not set..
		if(this._width > 0)this.scale.x = this._width / this.texture.frame.width;
		if(this._height > 0)this.scale.y = this._height / this.texture.frame.height;
		
		this.updateFrame = true;
		
	}
	
	
	/**
	 * Sets the texture of the sprite
	 *
	 * @method setTexture
	 * @param texture {Texture} The PIXI texture that is displayed by the sprite
	 */
	public function setTexture (texture:Texture):Void {
		
		// stop current texture;
		if(this.texture.baseTexture != texture.baseTexture)
		{
			this.textureChange = true;	
			this.texture = texture;
			
			if(this.__renderGroup != null)
			{
				this.__renderGroup.updateTexture(this);
			}
		}
		else
		{
			this.texture = texture;
		}
		
		this.updateFrame = true;
		
	}
	
	// some helper functions..
	
	/**
	 * 
	 * Helper function that creates a sprite that will contain a texture from the TextureCache based on the frameId
	 * The frame ids are created when a Texture packer file has been loaded
	 *
	 * @method fromFrame
	 * @static
	 * @param frameId {String} The frame Id of the texture in the cache
	 * @return {Sprite} A new Sprite using a texture from the texture cache matching the frameId
	 */
	public static function fromFrame (frameId:String):Sprite {
		
		var texture = Pixi.TextureCache[frameId];
		if(texture == null)throw ("The frameId '"+ frameId +"' does not exist in the texture cache");
		return new Sprite(texture);
		
	}
	
	
	/**
	 * 
	 * Helper function that creates a sprite that will contain a texture based on an image url
	 * If the image is not in the texture cache it will be loaded
	 *
	 * @method fromImage
	 * @static
	 * @param imageId {String} The image url of the texture
	 * @return {Sprite} A new Sprite using a texture from the texture cache matching the image id
	 */
	public static function fromImage (imageId:String):Sprite {
		
		var texture = Texture.fromImage(imageId);
		return new Sprite(texture);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_height ():Float {
		
		return this.scale.y * this.texture.frame.height;
		
	}
	
	private function set_height (value:Float):Float {
		
		this.scale.y = value / this.texture.frame.height;
		this._height = value;
		return value;
		
	}
	
	
	private function get_width ():Float {
		
		return this.scale.x * this.texture.frame.width;
		
	}
	
	private function set_width (value:Float):Float {
		
		this.scale.x = value / this.texture.frame.width;
		this._width = value;
		return value;
		
	}
	
	
}