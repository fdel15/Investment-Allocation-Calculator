<script>
  import { createEventDispatcher } from 'svelte'
  const dispatch = createEventDispatcher();

  function handleChange() {
    dispatch('update', {
      investor: investor
    })
  }

  function handleClick() {
    dispatch('delete', {
      id: id
    })
  }

  export let id;
  export let name = '';
  export let averageAmount;
  export let requestedAmount;
  export let allocatedAmount = undefined

  function roundedAllocationAmount(amount) {
    if(amount) {
      return Math.round(amount * 100000) / 100000
    } else {
      return 0
    }
  }
  
  $: investor = {id, name, averageAmount, requestedAmount, allocatedAmount}
</script>

  <td><input placeholder='Name' bind:value={name} on:change={handleChange}></td>
  <td><input placeholder='Average Amount' type=number bind:value={averageAmount} on:change={handleChange}></td>
  <td><input placeholder='Requested Amount' type=number bind:value={requestedAmount} on:change={handleChange}></td>
  <td>{roundedAllocationAmount(allocatedAmount)}</td>
  <td><a id='delete' on:click={handleClick}>&#9747;</a></td>

<style>
  td {
    padding: 5px;
  }

  #delete {
    display: inline-block;
    color: #981010;
    font-size: 20px;
  }
</style>

