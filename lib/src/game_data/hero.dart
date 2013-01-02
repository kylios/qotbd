part of game_data;

class Hero extends Player {

  Hero(AssetManager assets, int x, int y) :

    super(2, 3,
        new ImageList([
          assets.getImage('p_up1'),
          assets.getImage('p_up2'),
          assets.getImage('p_up3'),
          assets.getImage('p_up4'),
          assets.getImage('p_up5'),
          assets.getImage('p_up6'),
          assets.getImage('p_up7'),
          assets.getImage('p_up8'),
          assets.getImage('p_up9')
        ]),
        new ImageList([
          assets.getImage('p_down1'),
          assets.getImage('p_down2'),
          assets.getImage('p_down3'),
          assets.getImage('p_down4'),
          assets.getImage('p_down5'),
          assets.getImage('p_down6'),
          assets.getImage('p_down7'),
          assets.getImage('p_down8'),
          assets.getImage('p_down9')
        ]),
        new ImageList([
          assets.getImage('p_left1'),
          assets.getImage('p_left2'),
          assets.getImage('p_left3'),
          assets.getImage('p_left4'),
          assets.getImage('p_left5'),
          assets.getImage('p_left6'),
          assets.getImage('p_left7'),
          assets.getImage('p_left8'),
          assets.getImage('p_left9')
        ]), new ImageList([
          assets.getImage('p_right1'),
          assets.getImage('p_right2'),
          assets.getImage('p_right3'),
          assets.getImage('p_right4'),
          assets.getImage('p_right5'),
          assets.getImage('p_right6'),
          assets.getImage('p_right7'),
          assets.getImage('p_right8'),
          assets.getImage('p_right9')
        ]))
  {
    this.setPosition(x, y);
  }
}