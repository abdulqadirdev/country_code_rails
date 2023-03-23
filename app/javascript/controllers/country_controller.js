import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="country"
let country 
let states 
let cities 
const csrf = document.getElementsByName('csrf-token')[0].content

export default class extends Controller {
  connect() {
  }
  static targets = [
    'state', 'city'
  ]
  countryUpdate(e){
   this.fetchState(e.target.value)
   country = e.target.value
  }
  
  cityUpdate(e){
    this.fetchCity(e.target.value)
  }

  async fetchState(e){
    let data = this.myFetch('/state', 'POST', {e})
    data.then(result => {
      result = Object.entries(result[0]);
      this.setOption(this.stateTarget, result, 'array')
    })
    data.then(result => {
      this.setOption(this.cityTarget, result[1])
    })
  }
  async fetchCity(e){
    let data = this.myFetch('/city', 'POST', {e, country})
    data.then(result => {
      this.setOption(this.cityTarget, result)
    })
  }

  setOption(select, values , array){
    select.innerHTML = ""
    values.forEach((st, index) => {      
      let opt = document.createElement('option')
      if (index == 0){
        opt.setAttribute('selected', true)
      }
      if (array){
        opt.value = st[0]
        opt.innerText = st[1]
      }else {
        opt.value = st
        opt.innerText = st
      }
      select.append(opt)
    });
  }

 async myFetch(url, method, body={}){
    const response = await fetch(url, {
      method: method,
       headers: {
        'X-CSRF-Token': csrf,
        'Content-Type': 'application/json',
       },
       body: JSON.stringify(body)
      })
      return await response.json()
  }

}
