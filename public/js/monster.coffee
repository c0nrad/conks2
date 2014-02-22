class Monster
  constructor: (X, Y, @scene) ->
    console.log "MONSTA!!!", X, Y

    @geometry = new THREE.CubeGeometry(10, 10, 10)
    @material = new THREE.MeshBasicMaterial {color: 0xFFFF00 }
    @cube = new THREE.Mesh(@geometry, @material);
    @cube.position.z = 30
    @cube.position.x = X
    @cube.position.y = Y
    @counter = 0
    @alive = true

    @scene.add(@cube)
    @bullets = []

    #Moves towards player, it collides with player, player dies
    #If collides with bullet, monster dies

  remove: () ->
    @scene.remove(@cube)

  update: (pX, pY) ->
    @move(pX, pY)

  move: (pX, pY) ->
    #Monster Drop
    if @cube.position.z > 5
        @cube.position.z -= 5
        return

    #Monster Move
    dX = pX - @cube.position.x
    dY = pY - @cube.position.y 

    normalize = Math.sqrt(dX * dX + dY * dY)
    @cube.position.x  += dX / normalize * 3 
    @cube.position.y += dY / normalize * 3


    # delta = Math.atan(-dY/dX)

    # if dX > 0
    #     @cube.position.x += (Math.cos (-delta)) * 3
    #     @cube.position.y += (Math.sin (-delta)) * 3

    # else 
    #     @cube.position.x -= (Math.cos (-delta)) * 3
    #     @cube.position.y -= (Math.sin (-delta)) * 3
    

window.Monster = Monster