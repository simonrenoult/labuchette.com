<score>

  <div class="box" if={ players.length > 1 }>
    <a href="#" onclick="{ sortByHigherScoreFirst }">Trier par score décroissant</a>
  </div>

  <div each={ players } class="box">
    <div class="columns">
      <div class="column">
        <span class="title player-name">{ this.name }</span>
      </div>
      <div class="column">
        <div class="field is-grouped is-grouped-right">
          <p class="control">
            <button if={ !this.manualScore } type="button" class="button is-info">Score : { this.score || 0}</button>
          </p>
          <p class="control" if={ this.manualScore }>
            <input class="input is-info" type="number" ref="manualScore" placeholder="Nouveau score" value={ this.score }>
          </p>
          <p class="control" if={ this.manualScore }>
            <button class="button is-info" onclick={ setScoreManually }>OK</button>
          </p>
          <p class="control">
            <button class="button is-primary" onclick={ parent.addOne }>+1</button>
          </p>
          <p class="control">
            <button class="button is-primary" onclick={ parent.addFive }>+5</button>
          </p>
          <p class="control">
            <button class="button is-warning" onclick={ parent.toggleManualScore }>Manual</button>
          </p>
          <p class="control">
            <button class="button is-danger" onclick={ parent.reset }>Reset</button>
          </p>
        </div>
      </div>
    </div>
  </div>
  
  <div class="box">
    <form class="columns" onsubmit="{ registerPlayer }">
        <div class="column">
          <input id="register-player" class="input" ref="name" type="text" placeholder="Nom du joueur" autofocus>
        </div>
        <div class="column">
          <button type="submit" class="button is-primary">Ajouter un joueur</button>
        </div>
    </form>
    
    <div class="message is-danger" if={ error }>
      <div class="columns">
        <div class="column">
          <div class="message-header">
            Erreur
          </div>
          <div class="message-body">
            { error.message }
          </div>
        </div>
      </div>
    </div>
  </div>

  <script>
    this.players = []
    this.error = null
    
    registerPlayer(e) {
      e.preventDefault()
      
      const playerName = this.refs.name.value
      if (!playerName) {
        this.error = { message: "Le nom du joueur ne peut être vide." }
        return
      }
      
      if (playerName.length < 3) {
        this.error = { message: "Le nom du joueur doit faire plus de 3 caractères." }
        return
      }
      
      const playerAlreadyInGame = this.players.some(player => player.name.toLowerCase() === playerName.toLowerCase())
      if (playerAlreadyInGame) {
        this.error = { message: "Ce nom de joueur est déjà pris." }
        return;
      }
      
      this.error = null;
      this.refs.name.value = ""
      this.players.push({name: playerName, score: 0})
      document.getElementById("register-player").focus()
    }
    
    addOne(e) {
      e.preventDefault()
      e.item.score += 1
    }
    
    addFive(e) {
      e.preventDefault()
      e.item.score += 5
    }
    
    reset(e) {
      e.preventDefault()
      e.item.score = 0;
    }
    
    setScoreManually(e) {
      e.preventDefault()
      e.item.score = parseInt(this.refs.manualScore.value, 10)
      e.item.manualScore = false
    }
    
    toggleManualScore(e) {
      e.preventDefault()
      e.item.manualScore = true
    }
    
    sortByHigherScoreFirst(e) {
      e.preventDefault()
      this.players = this.players.sort((playerA, playerB) => playerB.score - playerA.score);
    }

  </script>
</score>
