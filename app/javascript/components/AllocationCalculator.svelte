<script>
  import Investor from './Investor.svelte'
  import Button from './Button.svelte'

  let allocationAmount = 0;
  let investors = [];

  function updateInvestor(event) {
    let updatedInvestor = event.detail.investor
    investors = investors.map(investor => {
      if(investor.id === updatedInvestor.id) {
        return updatedInvestor
      }
      else { return investor }
    })
  }

  function addInvestor() {
    investors.push({id: nextId() })
    investors = investors
  }

  function deleteInvestor(event) {
    let id = event.detail.id
    investors = investors.filter(investor => investor.id != id )
  }

  function nextId() {
    return investors.length === 0 ? 1 : investors[investors.length - 1].id + 1
  }

  async function calculateAllocations() {
  let validInvestors = investors.filter(investor => {
      return investor.id && investor.name && investor.averageAmount && investor.requestedAmount
   })

   if(validInvestors.length === 0 || allocationAmount === 0) {
     clearAllocations()
   } else {
      railsApiCall(allocationAmount, validInvestors)
   }
}

function clearAllocations() {
  investors = investors.map(investor => {
    return {...investor, allocatedAmount: 0 }
  })
}

async function railsApiCall(allocation_amount, investor_amounts) {
  let data = {allocation_amount, investor_amounts}

  return fetch("/calculate", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(data)
  }).then(async response => {
    if (response.ok) {
      let data = await response.json().catch(() => {})
      allocateAmounts(data)
    } else {
      console.log(response.statusText)
    }
  })
}

function allocateAmounts(data) {
    investors = investors.map(investor => {
      let allocation = data.find(allo => allo.id === investor.id)
  
      if(allocation) {
        return {...investor, allocatedAmount: allocation.allocatedAmount}
      } else { return investor }
    })
  }

</script>

<h1>Allocation Calculator</h1>

<div id='calculator'>
    <div id='allocation-amount'>
      <label>
        <span>Total Allocation Amount:</span>
        <input 
          type=number 
          placeholder='Allocation Amount' 
          bind:value={allocationAmount} 
        />
      </label>
   </div>

   <table>
     <thead>
      <tr>
        <th>Name</th>
        <th>Average Investment</th>
        <th>Requested Amount</th>
        <th>Allocated Amount</th>
        <th></th>
       </tr>
     </thead>

     <tbody>
       {#each investors as investor (investor.id)}
        <tr>
          <Investor 
            id={investor['id']}
            name={investor['name']}
            requestedAmount={investor['requestedAmount']}
            averageAmount={investor['averageAmount']}
            allocatedAmount={investor['allocatedAmount']}
            on:update={updateInvestor}
            on:delete={deleteInvestor}
          />
        </tr>
      {/each}
     </tbody>
   </table>
</div>

<Button on:buttonClick={addInvestor} text="Add Investor" />
<Button on:buttonClick={calculateAllocations} text="Calculate" color="#1c1cea" />

<style>
  h1 { text-align: center;}
  #calculator {
    border: solid 1px black;
    margin: 10px;
    min-height: 250px;
  }

  #allocation-amount {
    margin: 10px;
  }

  #allocation-amount input {
    width: 150px;
  }

  table {
    width: 100% !important;
  }

  th {
    text-align: left;
    padding-left: 5px;
  }

  span {
    font-weight: bold;
    display: inline-block;
    margin-right: 10px;
  }
</style>