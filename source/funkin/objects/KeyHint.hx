package funkin.objects;

import flixel.util.FlxColor;
import flixel.util.typeLimit.OneOfTwo;
import funkin.input.InputFormatter;
import funkin.input.Controls;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import openfl.geom.Rectangle;
import flixel.math.FlxRect;
import flixel.input.keyboard.FlxKey;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import flixel.addons.display.FlxSliceSprite;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

using StringTools;

class KeyHint extends FlxTypedSpriteGroup<FlxSprite> {
    public var actionText:FlxText;
    public var keyText:FlxText;
    public var keys:Array<FlxKey>;
    public var border:Cooler9Slice;
    public var curKey:Int = 0;
    final min_width:Int = 32;

    override public function new(x:Float, y:Float, action:String, keys:OneOfTwo<String, Array<FlxKey>>, controls:Controls) {
        super(x, y);

        if (Std.isOfType(keys, String)) {
            this.keys = ['Hi'];
        } else {
            this.keys = keys;
        }
        border = new Cooler9Slice(0,0, Paths.image('optionsMenu/backdrop'), new Rectangle(22, 22, 89, 89));
        add(border);

        keyText = new FlxText(2,5,0,InputFormatter.getKeyName(keys[curKey]), 16);
        add(keyText);
        keyText.color = 0xFF000000;
        keyText.setFormat(Paths.font('helvetica.ttf'), 16, 0xFFFFFFFF, LEFT);

        border.resize(keyText.width + 4, keyText.height + 4);
        
        actionText = new FlxText(border.width + 2,2,0,action, 16);
        add(actionText);
        actionText.setFormat(Paths.font('quanticob.ttf'), 16, 0xFFFFFFFF, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        keyText.text = InputFormatter.getKeyName(keys[curKey]);
        if (this.keys.length > 1) {
            timerLoop();
        }
    }

    function widthChange(b:Cooler9Slice, value:Float) {
        b.resize(value, height);
    }

    function timerLoop() {
        FlxTween.tween(keyText, {alpha: 0}, 0.2, {startDelay: 3.6});
        new FlxTimer().start(4, tween);
    }
    function tween(?t:FlxTimer) {
        curKey = FlxMath.wrap(curKey+1, 0, keys.length - 1);
        keyText.text = InputFormatter.getKeyName(keys[curKey]);
        var predictedWidth = keyText.width + 4 >= min_width ? keyText.width + 4 : min_width;
        FlxTween.tween(actionText, {x: border.x + predictedWidth}, 1, {ease: FlxEase.backInOut});
        FlxTween.num(border.width, predictedWidth, 1, {ease: FlxEase.backInOut}, widthChange.bind(border));
        FlxTween.tween(keyText, {alpha: 1}, 0.6, {startDelay: 0.2});
        timerLoop();
    }
}