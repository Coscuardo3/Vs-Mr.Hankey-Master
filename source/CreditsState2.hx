package;

import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import openfl.Lib;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.system.FlxSound;

    //i took this code from friday night fever

typedef CreditCard = {
    var image:String;
    var ?link:String;
    var ?desc:String;
}

class CreditsState extends MusicBeatState
{
    var camFollow:FlxObject;
    var curSelected:Int = 0;
    var cards:Array<FlxSprite> = [];
    var credits:Array<CreditCard> = [
        //{image:"",link:""} blank
        {image:"coscuardo",link:"https://www.youtube.com/channel/UCpcfU_ZQIYQL0BhJa0rvQZg", desc:"The director"},
        {image:"dylan",link:"https://twitter.com/CesarFever_", desc:"Artist"},
        {image:"fattus",link:"https://twitter.com/teabunnies02", desc:"Artist"},
        {image:"chumder",link:"https://www.youtube.com/channel/UCWBR4yI26FCXiR-r27HPmwg", desc:"Composer"},
    ];
    var description:FlxText;

    override function create()
    {
        super.create();

        FlxG.save.data.visitedCredits = true;
        FlxG.save.flush();

        var bg:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('credits/bg'));
        bg.scrollFactor.set();
        bg.screenCenter(Y);
        bg.screenCenter(X);
        bg.setGraphicSize(Std.int(bg.width * 1.35));
        bg.antialiasing = true;
        add(bg);

        camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

        FlxG.camera.follow(camFollow, null, 0.065 * (60 / (cast(Lib.current.getChildAt(0), Main)).getFPSCap() ));

        for(i in 0...credits.length)
        {
            var card:FlxSprite = new FlxSprite(0, 60 + (205 * i)).loadGraphic(Paths.image('credits/${credits[i].image.toLowerCase()}', 'preload'));
            card.scale.set(0.8, 0.8);
            card.antialiasing = true;
            card.alpha = 0.6;
            card.screenCenter(X);
            add(card);
            card.ID = i;
            cards.push(card);
        }

        var logo:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('credits/LogoKN'));
        add(logo);
        logo.scrollFactor.set();
        logo.antialiasing = true;
        logo.y -= 250;
        logo.x -= -615;
        logo.scale.set(0.3, 0.3);

        description = new FlxText(0, FlxG.height * 0.95, 0, "Placeholder", 24);
        description.alpha = 0.87;
        description.setFormat(Paths.font("Questrian.otf"), 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        description.scrollFactor.set();
        add(description);

        changeSelection();
    }

    override function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.ESCAPE)
        {
            FlxG.switchState(new MainMenuState());
        }
        super.update(elapsed);

        if(controls.UP_P)
            changeSelection(-1);

        if(controls.DOWN_P)
            changeSelection(1);

        if(controls.ACCEPT)
        {
            if(credits[curSelected].link != '' && credits[curSelected].link != null)
            {
                #if linux
                Sys.command('/usr/bin/xdg-open', [credits[curSelected].link, "&"]);
                #else
                FlxG.openURL(credits[curSelected].link);
                #end    
            }
        }
    }

    function changeSelection(change:Int = 0)
    {
        FlxTween.tween(cards[curSelected], {"scale.x": 0.8, "scale.y": 0.8, alpha:0.6}, 0.14);
        curSelected += change;
        FlxG.sound.play(Paths.sound('scrollMenu'));
        if(curSelected >= credits.length)
            curSelected = 0;
        else if(curSelected < 0)
            curSelected = credits.length - 1;

        camFollow.setPosition(cards[curSelected].getGraphicMidpoint().x, cards[curSelected].getGraphicMidpoint().y);
        FlxTween.tween(cards[curSelected], {"scale.x": 0.86, "scale.y": 0.86, alpha:1}, 0.14);
    
        description.text = credits[curSelected].desc;
        description.screenCenter(X);
    }
}