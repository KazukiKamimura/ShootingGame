/* @pjs preload="title.png"; */

//変数
String scene;
Start start;
HowToPlay howToPlay;
Stage stage;
Player player;
Enemy enemy;

void setup() {
  size(1500, 1500);
  background(0, 0, 0);
  noStroke();
  frameRate(30);
  PFont font = createFont("メイリオ", 50);
  textFont(font);
  textAlign(CENTER, CENTER);
  scene="start";
  start = new Start();
  start.createStar();
  start.crateShootingStar();
  howToPlay = new HowToPlay();
  stage = new Stage();
  stage.setupBackground();
  player=new Player();
  enemy=new Enemy();
  enemy.setEnemy();
}

void draw() {
  if (scene=="start") {
    background(30, 0, 80);
    stage.setBLACKOUTFRAG(2);
    start.drawStar();
    start.drawShootingStar();
    start.startButton();
    start.drawTitle();
    start.howToPlayButton();
  } else if (scene=="howToPlay") {
    background(30, 0, 80);
    start.drawStar();
    start.drawShootingStar();
    howToPlay.drawtext();
    howToPlay.returnButton();
  } else if (scene=="stage") {
    stage.blackOut();
    if (stage.blackOutFrag==1) {
      if (player.playerBroken()) {
        stage.drawGameover();
      } else {
        stage.drawBackground();
        stage.drawBody();
        stage.drawStatus();
      }
    }
  } else if (scene=="clear") {
    stage.drawGameclear();
  }
}
void drawButton(float x, float y, float dx, float dy) {
  strokeWeight(5);
  stroke(0, 255, 255);
  if (pushButton(x, y, dx, dy)) {
    fill(90, 125, 255);
  } else  if (touchButton(x, y, dx, dy)) {
    fill(151, 173, 255);
  } else {
    fill(205, 215, 255);
  }
  rect(x, y, dx, dy, 30);
  noStroke();
}
boolean touchButton(float x, float y, float dx, float dy) {
  if (mouseX>x && mouseX<x+dx && mouseY>y && mouseY<y+dy) {
    return true;
  } else {
    return false;
  }
}
boolean pushButton(float x, float y, float dx, float dy) {
  if (touchButton(x, y, dx, dy) && mousePressed) {
    return true;
  } else {
    return false;
  }
}

// 初期画面
class Start {
  int temp=0;
  // 星
  final int starAmount=60;                    // 星の数
  float[][] star=new float[starAmount][3];
  final int X=0;
  final int Y=1;
  final int R=2;

  void createStar() {
    for (int i=0; i<starAmount; i++) {
      star[i][X]=random(0, 1500);               // 星のX座標
      star[i][Y]=random(0, 1500);               // 星のY座標
      star[i][R]=random(1, 10);                 // 星の直径
    }
  }
  void drawStar() {
    for (int i=0; i<starAmount; i++) {
      fill(255);
      ellipse(star[i][X], star[i][Y], star[i][R], star[i][R]);
      if (star[i][R]>=10) {
        star[i][R]-=random(0, 1);
      } else if (star[i][R]<=0) {
        star[i][R]+=random(0, 1);
      } else {
        star[i][R]+=random(-1, 1);
      }
    }
  }

  // 流れ星
  float shootingStarX;
  float shootingStarY;
  float shootingStarR;
  final float shootingStarSpeed=10;
  int drawingNow=0;
  int drawingTime=1;

  void crateShootingStar() {
    shootingStarX=random(300, 1500);            // 流れ星のX座標
    shootingStarY=random(0, 1200);              // 流れ星のY座標
    shootingStarR=20;                           // 流れ星の直径
  }
  void drawShootingStar() {
    if (shootingStarR<=0) {
      crateShootingStar();
      drawingNow=0;
      drawingTime=0;
    }
    float random=random(0, 200);
    if ((random>=0 && random<=1)||drawingNow==1) {
      fill(255);
      for (int i=0; i<=drawingTime; i++) {
        ellipse(shootingStarX+shootingStarSpeed*i, shootingStarY-shootingStarSpeed*i/2, shootingStarR-0.3*i, shootingStarR-0.3*i);
      }
      shootingStarX-=shootingStarSpeed;
      shootingStarY+=shootingStarSpeed/2;
      shootingStarR-=0.3;
      drawingNow=1;
      if (drawingTime>10) {
        drawingTime=10;
      } else if (shootingStarR<=3) {
        drawingTime-=1;
      } else {
        drawingTime+=1;
      }
    }
  }
  // スタートボタン
  final float startButtonDX=700;
  final float startButtonDY=200;
  final float startButtonX=(width-startButtonDX)/2;
  final float startButtonY=height-500;

  void startButton() {
    drawButton(startButtonX, startButtonY, startButtonDX, startButtonDY);
    textSize(100);
    fill(255);
    text("START", width/2, startButtonY+startButtonDY/2);
    if (pushButton(startButtonX, startButtonY, startButtonDX, startButtonDY)) {
      temp=1;
    } else if (temp==1) {
      scene="stage";
      temp=0;
    }
  }
  // タイトル
  void drawTitle() {
    PImage title;
    title=loadImage("title.png");
    image(title, width/2-480, 100);
  }
  // 遊び方ボタン
  final float howToPlayButtonDX=400;
  final float howToPlayButtonDY=110;
  final float howToPlayButtonX=(width-howToPlayButtonDX)/2;
  final float howToPlayButtonY=height-700;
  void howToPlayButton() {
    drawButton(howToPlayButtonX, howToPlayButtonY, howToPlayButtonDX, howToPlayButtonDY);
    textSize(70);
    fill(255);
    text("遊び方", width/2, howToPlayButtonY+howToPlayButtonDY/2-8);
    if (pushButton(howToPlayButtonX, howToPlayButtonY, howToPlayButtonDX, howToPlayButtonDY)) {
      temp=2;
    } else if (temp==2) {
      scene="howToPlay";
      temp=0;
    }
  }
}

class HowToPlay {
  int temp=0;
  int temp2=0;
  String page="page1";
  // 本文
  void drawtext() {
    if (page=="page1") {
      scale(5);
      player.drawPlayer(width/2/5, (height-300)/5);
      scale(0.2);
      stage.drawStatus();
      fill(255);
      textSize(100);
      text("遊び方", width/2, 40);
      textSize(50);
      textAlign(LEFT, TOP); 
      text("マウスを動かして移動します。"+"\n"+
        "右端はゲージ類が存在しているため、移動できません。"+"\n"+
        "左クリックで前方に弾を発射することができます。"+"\n"+
        "右クリック長押しでバリアゲージを消費して"+"\n"+
        "バリアを展開することができます。"+"\n"+
        "バリアを展開している間はダメージを受けません。"+"\n"+
        "バリアゲージは時間経過で少しずつ回復します。"+"\n"+
        "敵の攻撃や敵の機体に当たるとダメージを受けます。"+"\n"+
        "５ダメージ受けてしまうとゲームオーバーです。"+"\n"+
        "今の体力は体力ゲージで確認することができます。", 30, 120);
      textAlign(CENTER, CENTER);
      nextButton();
    } else if (page=="page2") {
      float x=width/4/5;
      float y= (height-300)/5;
      scale(5);
      // 機体(下)
      fill(174, 251, 255);
      ellipse(x-17, y+9, 15, 15);
      ellipse(x, y+9, 20, 20);
      ellipse(x+17, y+9, 15, 15);
      // 機体(上)
      fill(111, 111, 111);
      rect(x-35, y+5, 70, 4);
      arc(x, y+5, 60, 40, PI, TWO_PI);
      rect(x-8, y-18, 16, 6);  
      // 丸窓
      fill(122, 228, 255);
      ellipse(x-16, y-2, 9, 9);
      ellipse(x, y-2, 11, 11);
      ellipse(x+16, y-2, 9, 9);
      // キャラ
      fill(120, 120, 120);
      ellipse(x, y-3, 5, 5);
      arc(x, y-2, 11, 12, radians(45), radians(135));
      x=width/4*2/5;
      y= (height-300)/5;
      // 機体(下)
      fill(255, 233, 181);
      ellipse(x-17, y+9, 15, 15);
      ellipse(x, y+9, 20, 20);
      ellipse(x+17, y+9, 15, 15);
      // 機体(上)
      fill(111, 111, 111);
      rect(x-35, y+5, 70, 4);
      arc(x, y+5, 60, 40, PI, TWO_PI);
      rect(x-8, y-18, 16, 6);  
      // 丸窓
      fill(255, 223, 85);
      ellipse(x-16, y-2, 9, 9);
      ellipse(x, y-2, 11, 11);
      ellipse(x+16, y-2, 9, 9);
      // キャラ
      fill(120, 120, 120);
      ellipse(x, y-3, 5, 5);
      arc(x, y-2, 11, 12, radians(45), radians(135));
      x=width/4*3/5;
      y= (height-300)/5;
      // 機体(下)
      fill(255, 169, 165);
      ellipse(x-17, y+9, 15, 15);
      ellipse(x, y+9, 20, 20);
      ellipse(x+17, y+9, 15, 15);
      // 機体(上)
      fill(111, 111, 111);
      rect(x-35, y+5, 70, 4);
      arc(x, y+5, 60, 40, PI, TWO_PI);
      rect(x-8, y-18, 16, 6);  
      // 丸窓
      fill(255, 119, 85);
      ellipse(x-16, y-2, 9, 9);
      ellipse(x, y-2, 11, 11);
      ellipse(x+16, y-2, 9, 9);
      // キャラ
      fill(120, 120, 120);
      ellipse(x, y-3, 5, 5);
      arc(x, y-2, 11, 12, radians(45), radians(135));

      scale(0.2);
      fill(255);
      textSize(100);
      text("遊び方", width/2, 40);
      textSize(50);
      textAlign(LEFT, TOP);
      text("敵は弾を飛ばして攻撃してきます。"+"\n"+
        "ボス以外の敵は１撃で倒すことができます。"+"\n"+
        "青い機体は普通の性能をしていますが、"+"\n"+
        "黄色い機体は弾の射程が通常の３倍です。"+"\n"+
        "赤い機体は弾の発射速度が２倍です。"+"\n"+
        "ステージの最後にはボス機体が出現し、特別な弾を発射します。"+"\n"+
        "体力が０になる前にボスを倒すことができれば、"+"\n"+
        "ゲームクリアです。", 30, 120);
      textAlign(CENTER, CENTER);
      backButton();
    }
  }
  //次へボタン
  final float nextButtonDX=100;
  final float nextButtonDY=100;
  final float nextButtonX=width/2+300-nextButtonDX;
  final float nextButtonY=height-10-nextButtonDY;
  void nextButton() {
    drawButton(nextButtonX, nextButtonY, nextButtonDX, nextButtonDY);
    textSize(80);
    fill(255);
    triangle(nextButtonX+nextButtonDX/2+20, nextButtonY+nextButtonDY/2, nextButtonX+nextButtonDX/2-20, nextButtonY+nextButtonDY/2+20, nextButtonX+nextButtonDX/2-20, nextButtonY+nextButtonDY/2-20);
    if (pushButton(nextButtonX, nextButtonY, nextButtonDX, nextButtonDY)) {
      temp2=1;
    } else if (temp2==1) {
      page="page2";
      temp2=0;
    }
  }
  //戻るボタン
  final float backButtonDX=100;
  final float backButtonDY=100;
  final float backButtonX=width/2-150-backButtonDX;
  final float backButtonY=height-10-backButtonDY;
  void backButton() {
    drawButton(backButtonX, backButtonY, backButtonDX, backButtonDY);
    textSize(80);
    fill(255);
    triangle(backButtonX+backButtonDX/2-20, backButtonY+backButtonDY/2, backButtonX+backButtonDX/2+20, backButtonY+backButtonDY/2+20, backButtonX+backButtonDX/2+20, backButtonY+backButtonDY/2-20);
    if (pushButton(backButtonX, backButtonY, backButtonDX, backButtonDY)) {
      temp2=1;
    } else if (temp2==1) {
      page="page1";
      temp2=0;
    }
  }
  // ホームに戻るボタン
  final float returnButtonDX=200;
  final float returnButtonDY=200;
  final float returnButtonX=10;
  final float returnButtonY=height-10-returnButtonDY;
  void returnButton() {
    drawButton(returnButtonX, returnButtonY, returnButtonDX, returnButtonDY);
    textSize(80);
    fill(255);
    text("戻る", returnButtonX+returnButtonDX/2, returnButtonY+returnButtonDY/2);
    if (pushButton(returnButtonX, returnButtonY, returnButtonDX, returnButtonDY)) {
      temp=1;
    } else if (temp==1) {
      scene="start";
      page="page1";
      temp=0;
    }
  }
}

class Stage {
  // 場面切り替え
  float time=0;
  int blackOutFrag;
  /* blackOutFrag
   0:実行状態
   1:待機状態
   2:実行状態への移行用
   */
  void setBLACKOUTFRAG(int x) {
    if (blackOutFrag!=x && blackOutFrag!=0) {  // ループ回避
      blackOutFrag=x;
    }
  }
  void blackOut() {
    if (time<=1 && blackOutFrag==0) {
      for (int i=0; i<=time*100; i++) {
        fill(0);
        rect(width/10*(i%10), height/10*floor(i/10), width/10, height/10);
      }
      time+=0.01;
    } else if (time>1) {
      background(0);
      fill(255);
      textSize(50);
      text("クリックしてスタート", width/2, height/2);
      if (mousePressed) {
        blackOutFrag=1;
      }
    } else if (blackOutFrag==2) {
      time=0;
      blackOutFrag=0;
    }
  }

  //背景
  final int starAmount=60;
  float[][] star=new float[starAmount][3];
  final int X=0;
  final int Y=1;
  final int R=2;
  void setupBackground() {
    for (int i=0; i<starAmount; i++) {
      star[i][X]=random(0, 1500);               // 星のX座標
      star[i][Y]=random(0, 1500);               // 星のY座標
      star[i][R]=random(1, 10);                 // 星の直径
    }
  }
  void drawBackground() {
    background(30, 0, 80);
    for (int i=0; i<starAmount; i++) {
      fill(255);
      ellipse(star[i][X], star[i][Y], star[i][R], star[i][R]);
      if (star[i][R]>=10) {
        star[i][R]-=random(0, 1);
      } else if (star[i][R]<=0) {
        star[i][R]+=random(0, 1);
      } else {
        star[i][R]+=random(-1, 1);
      }
      if (star[i][Y]<=height) {
        star[i][Y]++;
      } else if (star[i][Y]>height) {
        star[i][Y]=0;
      }
    }
  }
  void drawStatus() {
    // 体力(アイコン)
    final int heartX=width-50;
    final int heartY=height-50;
    fill(255, 81, 159);
    arc(heartX-20, heartY-10, 40, 40, radians(180), radians(360));
    arc(heartX+20, heartY-10, 40, 40, radians(180), radians(360));
    rect(heartX-40, heartY-10, 80, 2);
    triangle(heartX-40, heartY-8, heartX+40, heartY-8, heartX, heartY+37);
    // 体力(ゲージ)
    noFill();
    stroke(0);
    strokeWeight(10);
    rect(1420, 20, 50, 1360);
    fill(255, 131, 186);
    strokeWeight(2);
    quad(1420, 20+((float)1360/5*player.brokenLevel), 1470, 20+((float)1360/5*player.brokenLevel), 1470, 1380, 1420, 1380);
    noStroke();
    // バリア(アイコン)
    final int barrierX=width-150;
    final int barrierY=height-50;
    fill(217, 255, 255);
    rect(barrierX-30, barrierY-35, 60, 40);
    triangle(barrierX-30, barrierY+5, barrierX+30, barrierY+5, barrierX, barrierY+35);
    fill(131, 246, 255);
    rect(barrierX-25, barrierY-30, 50, 35);
    triangle(barrierX-25, barrierY+5, barrierX+25, barrierY+5, barrierX, barrierY+30);
    fill(135, 197, 255);
    rect(barrierX-20, barrierY-25, 40, 30);
    triangle(barrierX-20, barrierY+5, barrierX+20, barrierY+5, barrierX, barrierY+25);
    // バリア(ゲージ)
    noFill();
    stroke(0);
    strokeWeight(10);
    rect(barrierX-30, 20, 50, 1360);
    fill(172, 239, 255);
    strokeWeight(2);
    quad(barrierX-30, 20+((float)1360/100*(100-player.barrierScore)), barrierX+20, 20+((float)1360/100*(100-player.barrierScore)), barrierX+20, 1380, barrierX-30, 1380);
    noStroke();
  }
  int temp;
  void drawGameover() {
    fill(255, 0, 0);
    rect(0, 0, width, height);
    drawButton(width/2-250, height/2+50, 500, 100);
    fill(255);
    textSize(50);
    text("タイトルに戻る", width/2, height/2+90);
    textSize(100);
    text("GAME OVER", width/2, height/2-150);
    if (pushButton(width/2-250, height/2+50, 500, 100)) {
      temp=1;
    } else if (temp==1) {
      scene="start";
      stage.setupBackground();
      enemy.setEnemy();
      player.brokenLevel=0;
      player.barrierScore=100;
      enemy.bossHealth=200;
      temp=0;
      enemy.bossReady=false;
    }
  }
  void drawGameclear() {
    fill(137, 229, 255);
    rect(0, 0, width, height);
    drawButton(width/2-250, height/2+170, 500, 100);
    fill(255);
    textSize(50);
    text("タイトルに戻る", width/2, height/2+210);
    textSize(100);
    text("GAME CLEAR!!", width/2, height/2-150);
    int score=0;
    for (int i=0; i<50; i++) {
      final int Draw=3;
      if (enemy.enemy[Draw][i]==0) {
        score++;
      }
    }
    textSize(80);
    text("Score:"+score, width/2, height/2+40);
    if (pushButton(width/2-250, height/2+170, 500, 100)) {
      temp=1;
    } else if (temp==1) {
      scene="start";
      stage.setupBackground();
      enemy.setEnemy();
      player.brokenLevel=0;
      player.barrierScore=100;
      enemy.bossHealth=200;
      temp=0;
      enemy.bossReady=false;
    }
  }
  // 機体描画
  void drawBody() {
    player.drawPlayer(mouseX, mouseY);
    enemy.drawEnemys();
  }
}

class Player {
  float[][] bullet=new float[4][10];
  boolean readyShoot=true;
  boolean readyRecycle=true;
  final int bulletLimit=30;
  float barrierScore=100;
  boolean barrier=false;
  final int X=0;
  final int Y=1;
  final int Time=2;
  final int Type=2;
  final int Draw=3;
  /*
     Draw
   0:描画しない
   1:描画する
   */
  void drawPlayer(float x, float y) {
    if (!playerBroken()) {
      if (x<30) {
        x=30;
      }
      if (x>width-230) {
        x=width-230;
      }
      if (y<30) {
        y=30;
      }
      if (y>height-45) {
        y=height-45;
      }
      // 炎
      float fireY;
      fireY=random(25, 35);
      fill(255, 0, 0);
      ellipse(x, y+30, 8, fireY);
      fill(255, 153, 0);
      ellipse(x, y+30, 5, fireY-7);
      fill(255, 208, 0);
      ellipse(x, y+30, 2, fireY-13);
      // 羽
      fill(255, 0, 0);
      triangle(x-28, y+27, x-15, y+4, x-12, y+20);
      triangle(x+28, y+27, x+15, y+4, x+12, y+20);
      // 機体
      fill(255);
      triangle(x, y-30, x+18, y-6, x-18, y-6);
      quad(x+18, y-6, x-18, y-6, x-10, y+30, x+10, y+30);
      fill(255, 0, 0);
      triangle(x, y-30, x+12, y-14, x-12, y-14);
      // 丸窓
      fill(122, 228, 255);
      ellipse(x, y+5, 15, 15);
      // 攻撃
      if (mousePressed) {
        // 通常攻撃
        if (mouseButton==LEFT && readyShoot) {
          barrier=false;
          for (int i=0; i<10; i++) {
            if (bullet[Draw][i]==0 && readyRecycle) {
              bullet[X][i]=x;
              bullet[Y][i]=y-35;
              bullet[Time][i]=0;
              bullet[Draw][i]=1;
              readyRecycle=false;
            }
          }
          readyShoot=false;
          readyRecycle=true;
          // 特殊行動
        } else if (mouseButton==RIGHT && barrierScore>0) {
          if (barrierScore>=3) {
            barrierScore-=3;
            drawBarrier(x, y);
            for (int i=0; i<50; i++) {
              // 当たり判定(先端のみ)
              if (enemy.enemy[Type][i]!=3) {
                if ((enemy.bullet[X][i]-mouseX)*(enemy.bullet[X][i]-mouseX)+(enemy.bullet[Y][i]+5-mouseY)*(enemy.bullet[Y][i]+5-mouseY)<=55*55 ||
                  (enemy.bullet[X][i]-mouseX)*(enemy.bullet[X][i]-mouseX)+(enemy.bullet[Y][i]-5-mouseY)*(enemy.bullet[Y][i]-5-mouseY)<=55*55) {
                  enemy.bullet[Draw][i]=0;
                }
              } else if (enemy.enemy[Type][i]==3) {
                if ((enemy.bullet[X][i]-mouseX)*(enemy.bullet[X][i]-mouseX)+(enemy.bullet[Y][i]+7.5-mouseY)*(enemy.bullet[Y][i]+7.5-mouseY)<=55*55 ||
                  (enemy.bullet[X][i]-mouseX)*(enemy.bullet[X][i]-mouseX)+(enemy.bullet[Y][i]-7.5-mouseY)*(enemy.bullet[Y][i]-7.5-mouseY)<=55*55) {
                  enemy.bullet[Draw][i]=0;
                }
              }
            }
            barrier=true;
          } else {
            barrierScore=0;
            barrier=false;
          }
          readyShoot=false;
        } else {
          barrier=false;
        }
        if (barrierScore>=100) {
          barrierScore=100;
        } else {
          barrierScore+=0.5;
        }
      } else {
        readyShoot=true;
        barrier=false;
        if (barrierScore>=100) {
          barrierScore=100;
        } else {
          barrierScore+=0.5;
        }
      }
      fill(255, 249, 89);
      for (int i=0; i<10; i++) {
        if (bullet[Draw][i]==1) {
          ellipse(bullet[X][i], bullet[Y][i], 3, 10);
        }
        if (bullet[Time][i]>bulletLimit || bullet[Y][i]<=-5) {
          bullet[Draw][i]=0;
        }
        bullet[Time][i]++;
        bullet[Y][i]-=20;
      }
    }
  }
  void drawBarrier(float x, float y) {
    fill(211, 246, 255, 120);
    stroke(211, 246, 255);
    strokeWeight(3);
    ellipse(x, y+5, 110, 110);
    noStroke();
  }
  int brokenLevel=0;
  boolean readyDamage=true;
  boolean playerBroken() {
    boolean result=false;
    // 当たり判定
    for (int i=0; i<50; i++) {
      // 弾の判定
      if (enemy.bullet[Type][i]!=3) {
        if (enemy.bullet[X][i]+1.5>=mouseX-20 &&
          enemy.bullet[X][i]-1.5<=mouseX+20 &&
          enemy.bullet[Y][i]+5>=mouseY-30 &&
          enemy.bullet[Y][i]-5<=mouseY+30 &&
          enemy.bullet[Draw][i]==1 &&
          barrier==false) {
          result=true;
        }
      } else if (enemy.bullet[Type][i]==3) {
        if (enemy.bullet[X][i]+2.5>=mouseX-20 &&
          enemy.bullet[X][i]-2.5<=mouseX+20 &&
          enemy.bullet[Y][i]+7.5>=mouseY-30 &&
          enemy.bullet[Y][i]-7.5<=mouseY+30 &&
          enemy.bullet[Draw][i]==1 &&
          barrier==false) {
          result=true;
        }
      }
      // 機体の判定
      if (enemy.enemy[Type][i]!=3) {
        if (enemy.enemy[X][i]+35>=mouseX-20 &&
          enemy.enemy[X][i]-35<=mouseX+20 &&
          enemy.enemy[Y][i]+17>=mouseY-30 &&
          enemy.enemy[Y][i]-18<=mouseY+30 &&
          enemy.enemy[Draw][i]==1 &&
          barrier==false) {
          result=true;
        }
      } else if (enemy.enemy[Type][i]==3) {
        if (enemy.enemy[X][i]+105>=mouseX-20 &&
          enemy.enemy[X][i]-105<=mouseX+20 &&
          enemy.enemy[Y][i]+51>=mouseY-30 &&
          enemy.enemy[Y][i]-54<=mouseY+30 &&
          enemy.enemy[Draw][i]==1 &&
          barrier==false) {
          result=true;
        }
      }
    }
    if (brokenLevel>=5) {
      brokenLevel=5;
      return true;
    } else {
      if (result) {
        if (readyDamage) {
          brokenLevel++;
          fill(255, 0, 0);
          rect(0, 0, width, height);
          readyDamage=false;
        }
      } else {
        readyDamage=true;
        return false;
      }
      return false;
    }
  }
}
class Enemy {
  // 敵機描画
  int time=0;
  float[][] enemy=new float[4][50]; 
  final int X=0;
  final int Y=1;
  final int Type=2;
  final int Draw=3;
  /*
   Draw
   0:描画しない
   1:描画する
   */
  void setEnemy() {
    float randomX;
    time=2;
    enemy[X][0]=width/2;
    enemy[Y][0]=-20-150*time;
    time=5;
    enemy[X][1]=width/4;
    enemy[Y][1]=-20-150*time;
    enemy[X][2]=width/4*2;
    enemy[Y][2]=-20-150*time;
    enemy[X][3]=width/4*3;
    enemy[Y][3]=-20-150*time;
    time=8;
    enemy[X][4]=width/6;
    enemy[Y][4]=-20-150*time;
    enemy[X][5]=width/6*2;
    enemy[Y][5]=-40-150*time;
    enemy[X][6]=width/6*3;
    enemy[Y][6]=-60-150*time;
    enemy[X][7]=width/6*4;
    enemy[Y][7]=-80-150*time;
    enemy[X][8]=width/6*5;
    enemy[Y][8]=-100-150*time;
    time=15;
    enemy[X][9]=width/2;
    enemy[Y][9]=-20-150*time;
    time=18;
    enemy[X][10]=width/5;
    enemy[Y][10]=-20-150*time;
    enemy[X][11]=width/5*2;
    enemy[Y][11]=-20-150*time;
    enemy[X][12]=width/5*3;
    enemy[Y][12]=-20-150*time;
    enemy[X][12]=width/5*4;
    enemy[Y][12]=-20-150*time;
    time=23;
    enemy[X][13]=width/2;
    enemy[Y][13]=-20-150*time;
    time=24;
    enemy[X][14]=width/5*2;
    enemy[Y][14]=-20-150*time;
    enemy[X][15]=width/5*3;
    enemy[Y][15]=-20-150*time;
    time=27;
    enemy[X][16]=width/3;
    enemy[Y][16]=-20-150*time;
    enemy[X][17]=width/3*2;
    enemy[Y][17]=-20-150*time;
    time=30;
    enemy[X][18]=width/6;
    enemy[Y][18]=-20-150*time;
    enemy[X][19]=width/6*2;
    enemy[Y][19]=-20-150*time;
    enemy[X][20]=width/6*3;
    enemy[Y][20]=-20-150*time;
    enemy[X][21]=width/6*4;
    enemy[Y][21]=-20-150*time;
    enemy[X][22]=width/6*5;
    enemy[Y][22]=-20-150*time;
    time=34;
    enemy[X][23]=width/7*3;
    enemy[Y][23]=-20-150*time;
    enemy[X][24]=width/7*4;
    enemy[Y][24]=-20-150*time;
    time=35;
    enemy[X][25]=width/5;
    enemy[Y][25]=-20-150*time;
    enemy[X][26]=width/5*4;
    enemy[Y][26]=-20-150*time;
    time=36;
    randomX=random(width/5, width/5*4);
    enemy[X][27]=randomX;
    enemy[Y][27]=-20-150*time;
    time=37;
    enemy[X][28]=randomX-50;
    enemy[Y][28]=-20-150*time;
    enemy[X][29]=randomX+50;
    enemy[Y][29]=-20-150*time;
    time=39;
    randomX=random(width/5, width/5*4);
    enemy[X][30]=randomX;
    enemy[Y][30]=-20-150*time;
    time=40;
    enemy[X][31]=randomX-50;
    enemy[Y][31]=-20-150*time;
    enemy[X][32]=randomX+50;
    enemy[Y][32]=-20-150*time;
    time=43;
    randomX=random(width/3, width/3*2);
    enemy[X][33]=randomX-150;
    enemy[Y][33]=-20-150*time;
    time=44;
    enemy[X][34]=randomX-200;
    enemy[Y][34]=-20-150*time;
    enemy[X][35]=randomX-100;
    enemy[Y][35]=-20-150*time;
    enemy[X][36]=randomX+150;
    enemy[Y][36]=-20-150*time;
    time=45;
    enemy[X][37]=randomX+100;
    enemy[Y][37]=-20-150*time;
    enemy[X][38]=randomX+200;
    enemy[Y][38]=-20-150*time;
    time=48;
    randomX=random(width/3, width/3*2);
    enemy[X][39]=randomX;
    enemy[Y][39]=-20-150*time;
    time=49;
    enemy[X][40]=randomX-50;
    enemy[Y][40]=-20-150*time;
    enemy[X][41]=randomX+50;
    enemy[Y][41]=-20-150*time;
    time=50;
    enemy[X][42]=randomX-100;
    enemy[Y][42]=-20-150*time;
    enemy[X][43]=randomX+100;
    enemy[Y][43]=-20-150*time;
    time=53;
    randomX=random(width/3, width/3*2);
    enemy[X][44]=randomX;
    enemy[Y][44]=-20-150*time;
    time=54;
    enemy[X][45]=randomX-75;
    enemy[Y][45]=-20-150*time;
    enemy[X][46]=randomX+75;
    enemy[Y][46]=-20-150*time;
    time=55;
    enemy[X][47]=randomX-150;
    enemy[Y][47]=-20-150*time;
    enemy[X][48]=randomX+150;
    enemy[Y][48]=-20-150*time;
    time=60;
    enemy[X][49]=width/2;
    enemy[Y][49]=-40-150*time;
    enemy[Type][49]=3;
    enemy[Draw][49]=1;
    r[49]=10;

    for (int i=0; i<49; i++) {
      if (i<=8 || i==13 || i==18 || i==22 || i==27 || i==39) {
        enemy[Type][i]=0;
      } else if (i<=15 || i==19 || i==21 || i==28 || i==29 || i==30 || i==33 || i==36 || i==40 || i==41) {
        enemy[Type][i]=1;
      } else if (i<=48) {
        enemy[Type][i]=2;
      }
      enemy[Draw][i]=1;
      r[i]=10;
    }
    for (int i=0; i<50; i++) {
      if (i==49) {
        bullet[Draw][i]=0;
        bullet[Time][i]=0;
      } else {
        bullet[Draw][i]=1;
        bullet[Time][i]=0;
      }
    }
  }
  boolean bossReady=false;
  void drawEnemys() {
    for (int i=0; i<50; i++) {
      drawEnemy(i);
      enemybullet(i);
      enemy[Y][i]+=5;
      if (bossReady) {
        enemy[Y][49]=height/4;
      } else {
        if (enemy[Y][49]>=height/4) {
          enemy[Y][49]=height/4;
          bullet[Draw][49]=1;
          bossReady=true;
        } else {
          bullet[Time][49]=0;
          bullet[Draw][49]=0;
        }
      }
    }
  }
  void drawEnemy(int number) {
    float x=enemy[X][number];
    float y=enemy[Y][number];
    float type=enemy[Type][number];
    float draw=enemy[Draw][number];
    if (draw==1) {
      if (type==0) {
        // 機体(下)
        fill(174, 251, 255);
        ellipse(x-17, y+9, 15, 15);
        ellipse(x, y+9, 20, 20);
        ellipse(x+17, y+9, 15, 15);
        // 機体(上)
        fill(111, 111, 111);
        rect(x-35, y+5, 70, 4);
        arc(x, y+5, 60, 40, PI, TWO_PI);
        rect(x-8, y-18, 16, 6);  
        // 丸窓
        fill(122, 228, 255);
        ellipse(x-16, y-2, 9, 9);
        ellipse(x, y-2, 11, 11);
        ellipse(x+16, y-2, 9, 9);
        // キャラ
        fill(120, 120, 120);
        ellipse(x, y-3, 5, 5);
        arc(x, y-2, 11, 12, radians(45), radians(135));
      } else if (type==1) {
        // 機体(下)
        fill(255, 233, 181);
        ellipse(x-17, y+9, 15, 15);
        ellipse(x, y+9, 20, 20);
        ellipse(x+17, y+9, 15, 15);
        // 機体(上)
        fill(111, 111, 111);
        rect(x-35, y+5, 70, 4);
        arc(x, y+5, 60, 40, PI, TWO_PI);
        rect(x-8, y-18, 16, 6);  
        // 丸窓
        fill(255, 223, 85);
        ellipse(x-16, y-2, 9, 9);
        ellipse(x, y-2, 11, 11);
        ellipse(x+16, y-2, 9, 9);
        // キャラ
        fill(120, 120, 120);
        ellipse(x, y-3, 5, 5);
        arc(x, y-2, 11, 12, radians(45), radians(135));
      } else if (type==2) {
        // 機体(下)
        fill(255, 169, 165);
        ellipse(x-17, y+9, 15, 15);
        ellipse(x, y+9, 20, 20);
        ellipse(x+17, y+9, 15, 15);
        // 機体(上)
        fill(111, 111, 111);
        rect(x-35, y+5, 70, 4);
        arc(x, y+5, 60, 40, PI, TWO_PI);
        rect(x-8, y-18, 16, 6);  
        // 丸窓
        fill(255, 119, 85);
        ellipse(x-16, y-2, 9, 9);
        ellipse(x, y-2, 11, 11);
        ellipse(x+16, y-2, 9, 9);
        // キャラ
        fill(120, 120, 120);
        ellipse(x, y-3, 5, 5);
        arc(x, y-2, 11, 12, radians(45), radians(135));
      } else if (type==3) {
        x=x/3;
        y=y/3;
        scale(3);
        // 機体(下)
        fill(145, 161, 255);
        ellipse(x-17, y+9, 15, 15);
        ellipse(x, y+9, 20, 20);
        ellipse(x+17, y+9, 15, 15);
        // 機体(上)
        fill(144, 144, 144);
        rect(x-35, y+5, 70, 4);
        arc(x, y+5, 60, 40, PI, TWO_PI);
        rect(x-8, y-18, 16, 6);  
        // 丸窓
        fill(137, 155, 255);
        ellipse(x-16, y-2, 9, 9);
        ellipse(x, y-2, 11, 11);
        ellipse(x+16, y-2, 9, 9);
        // キャラ
        fill(120, 120, 120);
        ellipse(x, y-3, 5, 5);
        arc(x, y-2, 11, 12, radians(45), radians(135));
        scale(0.333333333);
        drawBossHealth();
      }
      if (enemyBroken(number)) {
        enemy[Draw][number]=0;
      }
    } else {
      drawDestroy(x, y, number);
    }
  }
  boolean readyDamage=true;
  boolean enemyBroken(int number) {
    float x=enemy[X][number];
    float y=enemy[Y][number];
    float type=enemy[Type][number];
    int bossTime=0;
    boolean result=false;
    boolean result2=false;
    // 当たり判定
    for (int i=0; i<10; i++) {
      // 弾の判定
      if (type!=3) {
        if (player.bullet[X][i]+1.5>=x-35 &&
          player.bullet[X][i]-1.5<=x+35 &&
          player.bullet[Y][i]+5>=y-18 &&
          player.bullet[Y][i]-5<=y+17 &&
          player.bullet[Draw][i]==1) {
          result=true;
        }
      } else {
        if (player.bullet[X][i]+1.5>=x-105 &&
          player.bullet[X][i]-1.5<=x+105 &&
          player.bullet[Y][i]+5>=y-54 &&
          player.bullet[Y][i]-5<=y+51 &&
          player.bullet[Draw][i]==1) {
          result=true;
        }
      }
      // 機体の判定
      if (mouseX+20>=x-35 &&
        mouseX-20<=x+35 &&
        mouseY+30>=y-18 &&
        mouseY-30<=y+17) {
        result2=true;
      }
    }
    if (type==3) {
      if (bossTime<=0) {
        bossTime=0;
      } else {
        bossTime--;
      }
    }
    if (result) {
      if (type!=3) {
        return true;
      } else if (bossTime==0) {
        if (bossHealth>0) {
          bossHealth--;
          bossTime=30;
        } else {
          bossHealth=0;
          return true;
        }
      }
    }
    if (result2) {
      if (type!=3) {
        return true;
      } else {
        if (readyDamage) {
          if (bossHealth>0) {
            bossHealth--;
            bossTime=30;
          } else {
            bossHealth=0;
            return true;
          }
          readyDamage=false;
        }
      }
    } else if (type==3) {
      readyDamage=true;
    }
    return false;
  }
  // 破壊
  int[] r=new int[50];
  void drawDestroy(float x, float y, int number) {
    int theta=0;
    for (int i=0; i<12; i++) {
      fill(255, 255, 255, 255-(r[number]-4));
      ellipse(x+r[number]*cos(radians(theta)), y+r[number]*sin(radians(theta)), 5, 5);
      theta+=360/12;
    }
    r[number]+=5;
    if (number==49 && 255-(r[number]-4)<=0) {
      scene="clear";
    }
  }
  // 敵の攻撃
  float[][] bullet=new float[4][55];
  final int Time=2;
  void enemybullet(int number) {
    float x=enemy[X][number];
    float y=enemy[Y][number];
    float type=enemy[Type][number];
    float draw=enemy[Draw][number];
    if (draw==1) {
      if (type==0) {
        if (bullet[Time][number]%70>=0 && bullet[Time][number]%70<=20) {
          y+=15*(bullet[Time][number]%70);
          if (bullet[Draw][number]==1) {
            bullet[X][number]=x;
            bullet[Y][number]=y+15;
            fill(0, 0, 255);
            stroke(255);
            strokeWeight(2);
            ellipse(x, y+15, 3, 10);
            noStroke();
          } else if (bullet[Draw][number]==0 && bullet[Time][number]%70>=0 && bullet[Time][number]%70<=1) {
            bullet[Draw][number]=1;
          }
        } else {
          bullet[Draw][number]=0;
        }
      } else if (type==1) {
        if (bullet[Time][number]%90>=0 && bullet[Time][number]%90<=60) {
          y+=15*(bullet[Time][number]%90);
          if (bullet[Draw][number]==1) {
            bullet[X][number]=x;
            bullet[Y][number]=y+15;
            fill(255, 255, 0);
            stroke(255);
            strokeWeight(2);
            ellipse(x, y+15, 3, 10);
            noStroke();
          } else if (bullet[Draw][number]==0 && bullet[Time][number]%90>=0 && bullet[Time][number]%90<=1) {
            bullet[Draw][number]=1;
          }
        } else {
          bullet[Draw][number]=0;
        }
      } else if (type==2) {
        if (bullet[Time][number]%35>=0 && bullet[Time][number]%35<=20) {
          y+=15*(bullet[Time][number]%35);
          if (bullet[Draw][number]==1) {
            bullet[X][number]=x;
            bullet[Y][number]=y+15;
            fill(255, 0, 0);
            stroke(255);
            strokeWeight(2);
            ellipse(x, y+15, 3, 10);
            noStroke();
          } else if (bullet[Draw][number]==0 && bullet[Time][number]%35>=0 && bullet[Time][number]%35<=1) {
            bullet[Draw][number]=1;
          }
        } else {
          bullet[Draw][number]=0;
        }
      } else if (type==3) {
        if (bullet[Time][number]%100>=0 && bullet[Time][number]%100<=90) {
          y+=15*(bullet[Time][number]%100);
          if (bullet[Draw][number]==1) {
            if (bullet[Time][number]%100>=0 && bullet[Time][number]%100<=1) {
              bullet[X][number]=x;
              bullet[Y][number]=y;
            }
            bullet[X][number]+=(mouseX-bullet[X][number])/12;
            bullet[Y][number]+=15+(mouseY-bullet[Y][number])/400*(bullet[Time][number]%100);
            fill(255, 0, 255);
            stroke(255);
            strokeWeight(2);
            ellipse(bullet[X][number], bullet[Y][number], 5, 15);
            noStroke();
          } else if (bullet[Draw][number]==0 && bullet[Time][number]%100>=0 && bullet[Time][number]%100<=1) {
            bullet[Draw][number]=1;
          }
        } else {
          bullet[Draw][number]=0;
        }
      }
    } else {
      bullet[X][number]=-10;
      bullet[Y][number]=-10;
    }
    bullet[Time][number]++;
  }
  int bossHealth=200;
  void drawBossHealth() {
    fill(255);
    rect(enemy[X][49]-50, enemy[Y][49]-30, 100, 10);
    if (bossHealth<=15) {
      fill(255, 0, 0);
    } else if (bossHealth<=50) {
      fill(255, 255, 0);
    } else {
      fill(0, 255, 255);
    }
    stroke(0);
    strokeWeight(1);
    rect(enemy[X][49]-50, enemy[Y][49]-30, bossHealth/2, 10);
    noFill();
    strokeWeight(2);
    rect(enemy[X][49]-50, enemy[Y][49]-30, 100, 10);
    noStroke();
  }
}
