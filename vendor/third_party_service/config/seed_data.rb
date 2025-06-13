# Since we're loading data from memory, seed it on each boot
#
# Seed the DB
Product.create!([
                  {
                    stock_keeping_unit_code: 'SKU-001',
                    stock_count: 100,
                    display_name: 'Wireless Mouse',
                    rating: 4,
                    details: 'Ergonomic wireless mouse with 2.4GHz connectivity.',
                    info: 'Compatible with Windows and macOS.',
                    price_amount: '29.99',
                    price_currency: 'USD',
                    tax_amount: '2.40',
                    tax_currency: 'USD'
                  },
                  {
                    stock_keeping_unit_code: 'SKU-002',
                    stock_count: 50,
                    display_name: 'Mechanical Keyboard',
                    rating: 5,
                    details: 'Backlit mechanical keyboard with blue switches.',
                    info: 'Includes wrist rest and macro support.',
                    price_amount: '79.99',
                    price_currency: 'USD',
                    tax_amount: '6.40',
                    tax_currency: 'USD'
                  },
                  {
                    stock_keeping_unit_code: 'SKU-003',
                    stock_count: 75,
                    display_name: 'Noise-Cancelling Headphones',
                    rating: 4,
                    details: 'Over-ear headphones with active noise cancellation.',
                    info: 'Up to 30 hours of battery life.',
                    price_amount: '129.99',
                    price_currency: 'USD',
                    tax_amount: '10.40',
                    tax_currency: 'USD'
                  },
                  {
                    stock_keeping_unit_code: 'SKU-004',
                    stock_count: 20,
                    display_name: '4K Monitor',
                    rating: 5,
                    details: '27-inch UHD display with HDR support.',
                    info: 'Ideal for graphic design and gaming.',
                    price_amount: '349.99',
                    price_currency: 'USD',
                    tax_amount: '28.00',
                    tax_currency: 'USD'
                  },
                  {
                    stock_keeping_unit_code: 'SKU-005',
                    stock_count: 200,
                    display_name: 'USB-C Hub',
                    rating: 3,
                    details: '7-in-1 USB-C hub with HDMI, USB 3.0, and SD card reader.',
                    info: 'Supports pass-through charging up to 100W.',
                    price_amount: '49.99',
                    price_currency: 'USD',
                    tax_amount: '4.00',
                    tax_currency: 'USD'
                  }
                ])
