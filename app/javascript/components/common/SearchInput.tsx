import React, { useRef, useState } from 'react'
import { GraphicalIcon } from './GraphicalIcon'

type SearchInputProps = {
  filter: string | undefined
  setFilter: (filter: string) => void
  placeholder: string
  className?: string
}

const WRAPPER_CLASSNAMES =
  'bg-unnamed15 text-textColor6 flex flex-row flex-grow rounded-[5px] border-1 border-transparent py-[11px] px-[21px] text-16 max-w-[420px] focus-within:focused-input hover:cursor-text'

const INPUT_CLASSNAMES = 'border-none bg-inherit !w-[100%] portable-input'
const ICON_CLASSNAMES = 'w-[24px] h-[24px] my-auto mr-[16px] filter-textColor6'

export function SearchInput({
  filter,
  setFilter,
  placeholder,
  className,
}: SearchInputProps): JSX.Element {
  const searchInputRef = useRef<HTMLInputElement>(null)
  const [focused, setFocused] = useState<boolean>(false)

  const focusInputElement = () => {
    searchInputRef.current?.focus()
  }

  return (
    <div
      className={`${WRAPPER_CLASSNAMES} ${className}`}
      onClick={focusInputElement}
    >
      <GraphicalIcon
        className={ICON_CLASSNAMES + (focused ? 'filter-none' : '')}
        icon="search"
      />
      <input
        onFocus={() => setFocused(true)}
        onBlur={() => setFocused(false)}
        ref={searchInputRef}
        type="text"
        className={INPUT_CLASSNAMES}
        style={{ all: 'unset' }}
        value={filter}
        onChange={(e) => setFilter(e.target.value)}
        placeholder={placeholder}
      />
    </div>
  )
}
